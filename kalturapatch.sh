#!/bin/sh
# kalturapatch.sh
#
# Patches the Kaltura Moodle plugin to support admin-configured custom LTI
# parameters that are sent to Kaltura on every launch request.
#
# Adds a "Custom LTI parameters" textarea to the admin settings page at:
#   Site Administration > Plugins > Local plugins > Kaltura package libraries
#
# Admins enter one parameter per line as key=value. Keys are automatically
# prefixed with "custom_" per the LTI spec if not already present.
#
# The following substitution variables are supported in values:
#   $Context.id, $Context.title, $Context.label
#   $User.id
#   $Person.name.full, $Person.name.given, $Person.name.family
#   $Person.email.primary, $Person.sourcedId
#   $Person.ubc.puid  (reads the 'puid' custom profile field)
#   $Person.ubc.cwl   (reads the 'cwl' custom profile field)
#
# Example admin config:
#   puid=$Person.ubc.puid
#   cwl=$Person.ubc.cwl
#   courseid=$Context.id
#
# Parameters are injected into every LTI launch (video resource, assignment,
# media gallery, etc.) via local_kaltura_request_lti_launch() in locallib.php.
#
# Files modified:
#   local/kaltura/lang/en/local_kaltura.php  — label and description strings
#   local/kaltura/settings.php               — textarea field in admin page
#   local/kaltura/locallib.php               — param parsing and injection
#
# Dockerfile usage:
#   COPY kalturapatch.sh /tmp/
#   RUN sh /tmp/kalturapatch.sh && rm /tmp/kalturapatch.sh

set -e

MOODLE_ROOT="${MOODLE_ROOT:-/var/www/html}"
LANG_FILE="$MOODLE_ROOT/local/kaltura/lang/en/local_kaltura.php"
SETTINGS_FILE="$MOODLE_ROOT/local/kaltura/settings.php"
LOCALLIB_FILE="$MOODLE_ROOT/local/kaltura/locallib.php"

# ── 1. Language strings (append to end of file) ──────────────────────────────
printf '\n' >> "$LANG_FILE"
cat >> "$LANG_FILE" << 'EOF'
$string['custom_params'] = 'Custom LTI parameters';
$string['custom_params_desc'] = 'Enter custom parameters to send to Kaltura on every LTI launch. One parameter per line in <code>key=value</code> format. Keys are automatically prefixed with <code>custom_</code> if not already present. Supported substitution variables: $Context.id, $Person.ubc.puid, $Person.ubc.cwl, and more.';
EOF

# ── 2. Admin settings textarea ───────────────────────────────────────────────
# Writes a PHP helper script that inserts the textarea field before the
# hide_if block in settings.php, then runs it with the php already on the image.
cat > /tmp/_kaltura_patch_settings.php << 'EOF'
<?php
$file = $argv[1];
$content = file_get_contents($file);
$insert = <<<'PHP'

    $adminsetting = new admin_setting_configtextarea(
        'custom_params',
        get_string('custom_params', 'local_kaltura'),
        get_string('custom_params_desc', 'local_kaltura'),
        '',
        PARAM_RAW,
        60,
        8
    );
    $adminsetting->plugin = KALTURA_PLUGIN_NAME;
    $settings->add($adminsetting);

PHP;
$content = str_replace("\r\n", "\n", $content);
$anchor = "\$settings->hide_if(KALTURA_PLUGIN_NAME.'/adminsecret'";
$content = str_replace($anchor, $insert . $anchor, $content);
file_put_contents($file, $content);
EOF
php /tmp/_kaltura_patch_settings.php "$SETTINGS_FILE"

# ── 3. Inject param parsing and substitution into locallib.php ───────────────
# Inserts after the existing custom_moodle_plugin_version line so all custom
# params are grouped together before the request is signed.
# UBC profile fields (puid, cwl) are loaded via profile_load_data() which is
# the same approach used elsewhere in UBC's Moodle for custom field lookups.
cat > /tmp/_kaltura_patch_locallib.php << 'EOF'
<?php
$file = $argv[1];
$content = file_get_contents($file);
$content = str_replace("\r\n", "\n", $content);
$anchor = "\$requestparams['custom_moodle_plugin_version'] = local_kaltura_get_config()->version;";
$insert = <<<'PHP'

    $rawparams = get_config(KALTURA_PLUGIN_NAME, 'custom_params');
    if (!empty($rawparams)) {
        if (isset($ltirequest['course'])) {
            $course = $ltirequest['course'];
        }
        profile_load_data($USER);
        $substitutions = [
            '$Context.id'           => $course->id,
            '$Context.title'        => $course->fullname,
            '$Context.label'        => $course->shortname,
            '$User.id'              => $USER->id,
            '$Person.name.full'     => fullname($USER),
            '$Person.name.given'    => $USER->firstname,
            '$Person.name.family'   => $USER->lastname,
            '$Person.email.primary' => $USER->email,
            '$Person.sourcedId'     => $USER->idnumber,
            '$Person.ubc.puid'      => array_key_exists('puid', $USER->profile) ? $USER->profile['puid'] : '',
            '$Person.ubc.cwl'       => array_key_exists('cwl', $USER->profile) ? $USER->profile['cwl'] : '',
        ];
        foreach (explode("\n", $rawparams) as $line) {
            $line = trim($line);
            if (empty($line) || strpos($line, '=') === false) {
                continue;
            }
            [$key, $value] = explode('=', $line, 2);
            $key   = trim($key);
            $value = str_replace(array_keys($substitutions), array_values($substitutions), trim($value));
            if (empty($key)) {
                continue;
            }
            if (strpos($key, 'custom_') !== 0) {
                $key = 'custom_' . $key;
            }
            $requestparams[$key] = $value;
        }
    }
PHP;
$content = str_replace($anchor, $anchor . $insert, $content);
file_put_contents($file, $content);
EOF
php /tmp/_kaltura_patch_locallib.php "$LOCALLIB_FILE"

# ── Cleanup ──────────────────────────────────────────────────────────────────
rm -f /tmp/_kaltura_patch_settings.php /tmp/_kaltura_patch_locallib.php
