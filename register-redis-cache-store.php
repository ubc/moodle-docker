<?php
// Idempotent CLI: registers a Moodle cache store named "redis_app" backed
// by the Redis instance at REDIS_HOST:REDIS_PORT. Run from the
// docker-entrypoint after Moodle is installed; safe to run on every start.
//
// Mode mappings (which caches use which store) are NOT set here — Moodle
// does not provide a reliable API for setting default mode mappings
// programmatically. Map Application/Request -> redis_app once via:
//   Site administration > Plugins > Caching > Configuration > Edit mappings
//
// Background: $CFG->cachestores in config.php looks plausible but is not
// consumed by Moodle's cache framework. The cache_config::instance()
// reads exclusively from moodledata/muc/config.php. The only programmatic
// path that actually persists a store is cache_config_writer.

define('CLI_SCRIPT', true);
require __DIR__ . '/config.php';

if (!getenv('REDIS_HOST')) {
    exit(0);
}

$writer = cache_config_writer::instance();
if (isset($writer->get_all_stores()['redis_app'])) {
    // already registered, no-op
    exit(0);
}

$ok = $writer->add_store_instance('redis_app', 'redis', [
    'server'     => getenv('REDIS_HOST') . ':' . (getenv('REDIS_PORT') ?: '6379'),
    'prefix'     => getenv('REDIS_PREFIX') ?: '',
    'serializer' => 1, // PHP serializer
]);

echo $ok ? "registered redis_app\n" : "add_store_instance(redis_app) returned false\n";
exit($ok ? 0 : 1);
