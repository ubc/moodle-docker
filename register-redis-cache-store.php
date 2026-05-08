<?php
// Idempotent CLI: ensures a Moodle cache store named "redis_app" exists and
// targets REDIS_HOST:REDIS_PORT. Run from the docker-entrypoint on every
// container start.
//
// Self-healing: if the store already exists with a different server (e.g.
// moodledata/muc/config.php was carried over from another env via shared
// NFS), the entry is reconciled to the current REDIS_HOST.
//
// Mode mappings (which caches use which store) are NOT set here — Moodle
// does not provide a reliable API for setting default mode mappings
// programmatically. Map Application/Request -> redis_app once via:
//   Site administration > Plugins > Caching > Configuration > Edit mappings
//
// Background: $CFG->cachestores in config.php looks plausible but is not
// consumed by Moodle's cache framework. cache_config::instance() reads
// exclusively from moodledata/muc/config.php. The only programmatic path
// that actually persists a store is cache_config_writer.

define('CLI_SCRIPT', true);
require __DIR__ . '/config.php';

if (!getenv('REDIS_HOST')) {
    exit(0);
}

$desired = [
    'server'     => getenv('REDIS_HOST') . ':' . (getenv('REDIS_PORT') ?: '6379'),
    'prefix'     => getenv('REDIS_PREFIX') ?: '',
    'serializer' => 1, // PHP serializer
];

$writer = cache_config_writer::instance();
$stores = $writer->get_all_stores();

if (isset($stores['redis_app'])) {
    $current = $stores['redis_app']['configuration'] ?? [];
    $needsUpdate = ($current['server'] ?? null) !== $desired['server']
        || ($current['prefix'] ?? '') !== $desired['prefix']
        || (int)($current['serializer'] ?? 0) !== $desired['serializer'];

    if (!$needsUpdate) {
        exit(0);
    }

    $ok = $writer->edit_store_instance('redis_app', 'redis', $desired);
    echo $ok
        ? "reconciled redis_app -> {$desired['server']}\n"
        : "edit_store_instance(redis_app) returned false\n";
    exit($ok ? 0 : 1);
}

$ok = $writer->add_store_instance('redis_app', 'redis', $desired);
echo $ok
    ? "registered redis_app -> {$desired['server']}\n"
    : "add_store_instance(redis_app) returned false\n";
exit($ok ? 0 : 1);
