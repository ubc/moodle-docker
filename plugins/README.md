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

> If you download a plugin from another source, make sure you rename the ZIP to follow this format. Otherwise, it will not be added to Moodle correctly.

## Plugin List

| Plugin                   | Link                                                     |
|--------------------------|----------------------------------------------------------|
| Heartbeat check          | https://moodle.org/plugins/tool_heartbeat                |
