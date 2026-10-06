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
| Certificate              | https://moodle.org/plugins/mod_certificate               |
| H5P                      | https://moodle.org/plugins/mod_hvp                       |
| Ad-hoc database queries  | https://moodle.org/plugins/report_customsql              |
| Grid Format              | https://moodle.org/plugins/format_grid                   |
| Flexible sections format | https://moodle.org/plugins/format_flexsections           |
| Mass enrolments          | https://moodle.org/plugins/local_mass_enroll             |
| Course Module navigation | https://moodle.org/plugins/block_course_modulenavigation |
| Merge user accounts      | https://moodle.org/plugins/tool_mergeusers               |
| Multi-Language Content v2| https://moodle.org/plugins/filter_multilang2             |
| Restriction by language  | https://moodle.org/plugins/availability_language         |
| Course recompletion      | https://moodle.org/plugins/local_recompletion            |
| Subcourse                | https://moodle.org/plugins/mod_subcourse                 |
| Zoom meeting             | https://moodle.org/plugins/mod_zoom                      |
| Custom certificate       | https://moodle.org/plugins/mod_customcert                |
| Arlo for Moodle          | https://moodle.org/plugins/enrol_arlo                    |