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
| Heartbeat check          | https://moodle.org/plugins/tool_heartbeat                |
