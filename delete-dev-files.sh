#!/usr/bin/env bash
# Remove paths from the Moodle release after extraction.
# Paths are relative to /var/www/html. Both files and directories are accepted.
set -euo pipefail

BASE=/var/www/html

# Exact paths (relative to $BASE) to remove.
REMOVE=(
    "check_lang_sort.sh"
    # NOTE: do NOT delete admin/environment.xml — it is runtime-required, not a
    # dev-only file. Moodle's environment check (admin "Environment" page and
    # every web/CLI upgrade) reads it via get_latest_version_available(). Without
    # it, check_moodle_environment() returns [false, []], which blanks the upgrade
    # "server checks" page and aborts admin/cli/upgrade.php at exit 1.
    "composer.json"
    "composer.lock"
    "package.json"
    "npm-shrinkwrap.json"
    "Gruntfile.js"
    "behat.yml.dist"
    "phpcs.xml.dist"
    "phpunit.xml.dist"
    "CONTRIBUTING.md"
    "COPYING.txt"
    "INSTALL.txt"
    "PATCH_UPGRADE_NOTES.md"
    "TRADEMARK.txt"
    "UPGRADING.md"
    "security.txt"
    ".eslintrc"
    ".gherkin-lintrc"
    ".gitattributes"
    ".github"
    ".gitignore"
    ".grunt"
    ".jshintignore"
    ".jshintrc"
    ".nvmrc"
    ".phpstorm.meta.php"
    ".shifter.json"
    ".stylelintrc"
    ".upgradenotes"
)

# Case-insensitive exact filenames matched recursively across the entire tree.
PATTERNS=(
    "readme"
    "readme.md"
    "readme.txt"
    "readme_moodle.txt"
    "readme.rst"
    "readme.html"
    "upgrade.txt"
    "upgrading.md"
    "upgrading-current.md"
)

for entry in "${REMOVE[@]}"; do
    target="${BASE}/${entry}"
    if [[ -e "$target" || -L "$target" ]]; then
        echo "Removing: $target"
        rm -rf "$target"
    else
        echo "Not found (skipping): $target"
    fi
done

for pattern in "${PATTERNS[@]}"; do
    find "$BASE" -depth -iname "$pattern" -printf "Removing: %p\n" -exec rm -rf {} +
done
