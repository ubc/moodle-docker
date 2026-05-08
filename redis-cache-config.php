<?php
// Predefine a Redis cache store named "redis_app" so it shows up in
// Moodle's Site administration > Plugins > Caching > Configuration page.
// Self-gated on REDIS_HOST so this is a no-op when redis isn't configured.
//
// Note: Moodle's per-mode mappings (application / session / request) live
// in moodledata/muc/config.php and need to be set ONCE via the admin UI:
//   Site admin > Plugins > Caching > Configuration > Edit mappings
// Map "Application" (and optionally "Request") to redis_app, then purge
// caches. The store predefinition below makes it a one-click choice; it
// does not auto-attach to a mode.
//
// Loaded from config.php immediately before lib/setup.php.

if (getenv('REDIS_HOST')) {
    $CFG->cachestores = [
        [
            'name'          => 'redis_app',
            'plugin'        => 'redis',
            'configuration' => [
                'server'     => getenv('REDIS_HOST') . ':' . (getenv('REDIS_PORT') ?: '6379'),
                'prefix'     => getenv('REDIS_PREFIX') ?: '',
                'serializer' => 1, // PHP serializer
            ],
            // Bitmask: searchable (2) + dataguarantee (4) + nativelocking (8) = 14
            'features'      => 14,
            // Bitmask: application (1) + request (2) = 3 (sessions handled separately)
            'modes'         => 3,
            'mappingsonly'  => false,
        ],
    ];
}
