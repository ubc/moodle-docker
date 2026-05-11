# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Docker image of **Moodle 4.5.11** on **PHP 8.3 / Apache**, published as `lthub/moodle` and consumed by the `charts/moodle` Helm chart for UBC LT Hub deployments. There is no PHP application code to build — Moodle source is downloaded by tag during `docker build`. This repo's "code" is the entrypoint, the templated `config.php`, the plugins bundle, and PHP/OPcache/Apache tuning in the Dockerfile.

## Common commands

```bash
# Local dev stack (mariadb + redis + web on :8080)
docker compose up --build

# Test variants — write to isolated .data-*-test/ volume trees so they don't
# stomp the dev stack. The base compose still provides db/web/redis service
# definitions; the overlay only changes ports, volumes, and env.
docker compose -f docker-compose.yml -f docker-compose.test-fpm.yml up --build      # :18080
docker compose -f docker-compose.yml -f docker-compose.test-opcache.yml up --build  # :18081

# Tear down + wipe local state
docker compose down -v && rm -rf .data .data-fpm-test .data-opcache-test

# Multi-arch build matching CI (linux/amd64 + linux/arm64)
docker buildx build --platform linux/amd64,linux/arm64 -t lthub/moodle:<tag> .
```

CI (`.github/workflows/main.yml`) builds and pushes `lthub/moodle:<branch-or-tag>` on every push. There is no test suite in this repo — verification is "stack comes up, Moodle installs, admin login works."

## Architecture

### Build pipeline (`Dockerfile`)
- Base: `php:8.3-apache`. Installs `pspell gd intl xml ldap zip soap mysqli opcache exif` and PECL `redis`, plus `graphviz`, `aspell`, `ghostscript` for Moodle's TeX/diagram features.
- Moodle source comes from `https://github.com/moodle/moodle/archive/v${MOODLE_VERSION}.tar.gz` — bumping Moodle = bumping `MOODLE_VERSION` in the Dockerfile.
- OPcache is pre-tuned for Moodle 4.5's ~15k PHP files: `memory_consumption=384`, `max_accelerated_files=24000`, `validate_timestamps=0`, tracing JIT with `jit_buffer_size=128M`. **`validate_timestamps=0` is intentional** — the image is immutable, every release rebuilds, and pod restart resets OPcache. Do not enable timestamp validation "for safety."
- Apache: `remoteip`, `rewrite`, `expires` modules enabled; `RemoteIPHeader X-Forwarded-For` trusts RFC1918 ranges; `LogFormat %h → %a` so logs reflect the real client behind the proxy.
- Plugins: every `plugins/*.zip` matching `<type>_<name>_<version>.zip` is extracted into the correct Moodle directory by a long `case "$type"` table in the Dockerfile. To add a plugin, drop the ZIP into `plugins/` named `<type>_<name>_<version>.zip` — the mapping must match Moodle's plugin layout (e.g. `mod_*` → `/var/www/html/mod/*`, `local_*` → `/var/www/html/local/*`, `theme_*` → `/var/www/html/theme/*`).

### Runtime (`docker-entrypoint.sh`)
Runs on every container start. The flow is:
1. Resolve DB connection from `MOODLE_DB_*` env, falling back to legacy `--link`-style vars (`MYSQL_PORT_3306_TCP_*`, `POSTGRES_PORT_5432_TCP_*`). Defaults to `mariadb`, port auto-picked by DB type.
2. Wait for the DB to be reachable via `nc`, then `CREATE DATABASE IF NOT EXISTS` for MySQL/MariaDB.
3. **Install-once** (gated by `$MOODLE_SHARED/installed` and a sibling `install.lock`): run `admin/cli/install_database.php` as `www-data`.
4. **Every start** (gated by `$MOODLE_SHARED/installed`): push SMTP/noreply settings (`smtphosts`, `smtpuser`, `smtppass`, `smtpsecure`, `smtpauthtype`, `noreplyaddress`) into `mdl_config` via `admin/cli/cfg.php`. This was previously install-only, which silently dropped changes for existing deployments — keep these idempotent and outside the install block.
5. If `REDIS_HOST` is set, run `register-redis-cache-store.php` to reconcile the `redis_app` MUC store (see below).
6. Optionally run `admin/cli/upgrade.php` when `MOODLE_UPDATE=true` (gated by `update.lock`).
7. `run-parts /docker-entrypoint.d` for any image consumer additions.
8. `exec` the CMD (Apache foreground).

Everything that touches Moodle as `www-data` uses `sudo -E -H -u www-data` — the `-H` resets `HOME` so Moodle doesn't write to `/root` and break perms on shared volumes.

### Config templating (`config.php`)
A real Moodle `config.php` checked in at the repo root and `COPY`ed to `/var/www/html/`. All site-specific values are read via a local `loadenv($name, $default)` helper. Env vars consumed:

| Var | Effect |
| --- | --- |
| `MOODLE_DB_TYPE` / `_HOST` / `_NAME` / `_USER` / `_PASSWORD` / `_PREFIX` / `_PORT` | DB connection. `dbcollation=utf8mb4_unicode_ci`. |
| `MOODLE_URL` | `$CFG->wwwroot` (no trailing slash). |
| `MOODLE_REVERSE_PROXY`, `MOODLE_SSL_PROXY` | Boolean flags for proxied/HTTPS-terminated deploys. |
| `MOODLE_NOEMAILEVER` | Boolean; set `true` on staging/test to suppress all outbound mail. **Must stay false in prod.** |
| `MOODLE_DISABLE_UPDATE_AUTODEPLOY` | Boolean; defaults to `true`. |
| `REDIS_HOST` / `REDIS_PORT` / `REDIS_DB` / `REDIS_PREFIX` | When `REDIS_HOST` is set, sessions switch to `\core\session\redis` automatically. |

Note: the dev `docker-compose.yml` exports `MOODLE_REDIS_HOST` but `config.php` and the entrypoint both read **`REDIS_HOST`** — production deployments (the Helm chart) set `REDIS_HOST` directly. The `MOODLE_REDIS_HOST` names in dev compose are dead env vars; if you change Redis behavior, work from `REDIS_HOST`.

### Redis as application cache (`register-redis-cache-store.php`)
**Important gotcha encoded in the repo:** Moodle's cache framework reads stores exclusively from `moodledata/muc/config.php`. The `$CFG->cachestores` array in `config.php` *looks* like it would register stores but is silently ignored. The only programmatic path that persists is `cache_config_writer::add_store_instance()` / `edit_store_instance()`. This script:
- No-ops if `REDIS_HOST` is unset.
- Adds a store named `redis_app` if missing.
- **Reconciles** server/prefix/serializer on every start if the entry exists with different values — this matters when `moodledata` is on shared NFS and an unrelated env's MUC config leaks in.

Mode mappings (Application/Request → `redis_app`) must still be set once via the admin UI: *Site administration → Plugins → Caching → Configuration → Edit mappings*. Moodle has no reliable API to set default mode mappings programmatically. Do not try to write `$CFG->cachestores` or hand-edit `muc/config.php` — both paths have failed historically.

### PHP runtime (`custom-php.ini`)
Variables in the ini are substituted at container start by PHP's env interpolation. Tune via env: `UPLOAD_MAX_FILESIZE`, `PHP_MEMORY_LIMIT`, `PHP_MAX_EXECUTION_TIME`, `PHP_MAX_INPUT_VARS`. Defaults are set in the Dockerfile (`20M / 128M / 30s / 6000`); the chart and the test overlays raise these.

## Known operational gotchas
- **NFS `/moodledata`** can produce `session data file is not created by your uid` because of UID-mapping drift between hosts. Workaround: use Redis sessions (set `REDIS_HOST`) — already enabled in production.
- **Plugin renames**: zips downloaded from moodle.org are often named `tool_heartbeat.zip` without version. The Dockerfile's case table relies on the `type_name_version.zip` pattern; rename before committing or the plugin lands in the wrong directory.
- Do not turn on `opcache.validate_timestamps` "just in case" — see Architecture note above.
- Do not move the install-time SMTP block back into the install-once branch — that regression has happened before.
