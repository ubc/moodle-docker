## Known Issues

* When using NFS shared volume for `/moodledata`, you may get `session data file is not created by your uid` error. It is due to the NFS mount user id mapping is not consistent with local user id. Use Redis session for workaround.
* By default Moodle's application cache uses a file store, which is slow. When `REDIS_HOST` is set, this image predefines a Redis cache store called `redis_app` that appears under `Site administration` -> `Plugins` -> `Caching` -> `Configuration`. To activate it for application/request caches:
  1. Verify `redis_app` shows up under "Configured store instances" with **Ready: Yes**.
  2. In the "Stores used when no mapping is present" section, click **Edit mappings**.
  3. Set **Application** -> `redis_app` (and **Request** -> `redis_app` if desired). Sessions already use Redis automatically via `$CFG->session_handler_class`.
  4. Save changes and **Purge all caches**.

  The store is registered by the docker-entrypoint via `cache_config_writer::add_store_instance()` (the only API that actually persists to `moodledata/muc/config.php` — `$CFG->cachestores` in `config.php` looks plausible but is silently ignored by Moodle's cache framework). Mode mappings still need the admin UI step on first install — Moodle has no reliable programmatic API for default mode mappings.
