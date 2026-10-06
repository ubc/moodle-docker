# Plugins

This folder contains a collection of plugins for [Moodle]. Each plugin is provided as a ZIP file that can be downloaded and installed as needed.

## Naming Convention

The Dockerfile expects the plugin ZIP files to follow a specific naming pattern: `type_pluginname_version.zip`
- `type` - The type of plugin, e.g., `mod`, `block`, `availability`, etc.
- `pluginname` - The plugins unique name.
- `version` - The version code (usually a date-based number, e.g., `2025093000`).

**Example:**
- mod_arlo_2025093000.zip
- block_quickmail_2025100100.zip

> Only the `type` prefix of the filename is used (to pick the install location). The plugin's folder name is read from `$plugin->component` in its `version.php`, so zips work whether the top-level folder is the plugin's short name (e.g. `course_modulenavigation/`) or a GitHub-style `moodle-block_completion_progress-2026083100/`.

## Plugin List

| Plugin                   | Link                                                     |
|--------------------------|----------------------------------------------------------|
| Questionnaire            | https://moodle.org/plugins/mod_questionnaire             |
| Level Up XP              | https://moodle.org/plugins/block_xp                      |
| Collapsed Topics         | https://moodle.org/plugins/format_topcoll                |
| Attendance               | https://moodle.org/plugins/mod_attendance                |
| Accessibility            | https://moodle.org/plugins/block_accessibility           |
| Multiple Choice          | https://moodle.org/plugins/qtype_multichoiceset          |
| AutoEnrol                | https://moodle.org/plugins/enrol_autoenrol               |
| Buttons                  | https://moodle.org/plugins/format_buttons                |
| Fordson Theme            | https://moodle.org/plugins/theme_fordson                 |
| Moove Theme              | https://moodle.org/plugins/theme_moove                   |
| Waxed Theme              | https://moodle.org/plugins/theme_waxed                   |
| Group choice             | https://moodle.org/plugins/mod_choicegroup               |
| Facetoface               | https://moodle.org/plugins/mod_facetoface                |
| Scheduler                | https://moodle.org/plugins/mod_scheduler                 |
| Configurable Reports     | https://moodle.org/plugins/block_configurable_reports    |
| H5P                      | https://moodle.org/plugins/mod_hvp                       |