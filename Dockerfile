FROM lthub/moodle:moodle-fpm
LABEL maintainer="Tyler Cinkant <tyler.cinkant@ubc.ca>"

# OS-level dependencies:
#  - libpq-dev: build-time only; needed to compile pgsql/pdo_pgsql below.
#    The base lthub/moodle image only installs mysqli; Moodle on Postgres
#    needs `pgsql` ($CFG->dbtype=pgsql consumes the procedural extension)
#    and `pdo_pgsql` (used by some PDO code paths).
#  - libimage-exiftool-perl: ships /usr/bin/exiftool, used by Moodle 4.5's
#    core_files\redactor\services\exifremover_service to strip EXIF metadata
#    out-of-process. Without it the service falls back to GD, which
#    decompresses every image into PHP RAM during course restores and OOMs
#    the cron pod (~28% progress on image-heavy courses). Must be paired
#    with $CFG->file_redactor_exifremovertoolpath = /usr/bin/exiftool in
#    Moodle config (the helm chart's exiftool-config-job Hook sets this).
ARG DEBIAN_FRONTEND=noninteractive
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends libpq-dev libimage-exiftool-perl; \
    docker-php-ext-install -j"$(nproc)" pgsql pdo_pgsql; \
    rm -rf /var/lib/apt/lists/*

# Overlay UBC's Moodle fork on top of the base image's upstream Moodle source.
# See https://github.com/ubc/moodle/tree/ltic-v4.5.11. Extracting WITHOUT
# wiping /var/www/html first preserves the deployment files placed there by
# the base image (config.php, register-redis-cache-store.php, the heartbeat
# plugin under admin/tool/heartbeat). The tarball overwrites the Moodle core
# files it ships and leaves everything else alone.
#
# Cost: ~250 MB extra in this layer — overlay-fs copy_up's every file written
# by tar even if the content matches. Accepted to keep this Dockerfile in
# lockstep with whatever lands on ubc/moodle:ltic-v4.5.11 without having to
# enumerate which files changed.
ARG MOODLE_LTIC_REF=ltic-v4.5.11
COPY delete-dev-files.sh /tmp/delete-dev-files.sh
RUN set -eux; \
    curl -fL "https://github.com/ubc/moodle/archive/${MOODLE_LTIC_REF}.tar.gz" \
      | tar xz --strip=1 -C /var/www/html; \
    bash /tmp/delete-dev-files.sh; \
    rm /tmp/delete-dev-files.sh; \
    chown -R www-data:www-data /var/www/html; \
    chmod 444 /var/www/html/config.php # Addresses "Writable config.php" moodle warning

# Fetching and unzipping all plugins
COPY plugins/ /plugins/
RUN set -eux; \
    cd /plugins; \
    for zip in *.zip; do \
        [ -f "$zip" ] || continue; \
        echo "Processing $zip..."; \
        type="${zip%%_*}"; \
        type=$(echo "$type" | tr '[:upper:]' '[:lower:]'); \
        name="${zip#*_}"; \
        name="${name%.zip}"; \
        \
        # Default destination (if type not matched below)
        dest="/var/www/html/${type}/${name}"; \
        \
        # Adjust destination for special cases
        case "$type" in \
            antivirus) dest="/var/www/html/lib/antivirus";; \
            assignfeedback) dest="/var/www/html/mod/assign/feedback";; \
            assignsubmission) dest="/var/www/html/mod/assign/submission";; \
            atto) dest="/var/www/html/lib/editor/atto/plugins";; \
            auth) dest="/var/www/html/auth";; \
            availability) dest="/var/www/html/availability/condition";; \
            block) dest="/var/www/html/blocks";; \
            booktool) dest="/var/www/html/mod/book/tool";; \
            cachelock) dest="/var/www/html/cache/locks";; \
            cachestore) dest="/var/www/html/cache/stores";; \
            calendartype) dest="/var/www/html/calendar/type";; \
            contenttype) dest="/var/www/html/contentbank/contenttype";; \
            coursereport) dest="/var/www/html/course/report";; \
            customfield) dest="/var/www/html/customfield/field";; \
            datafield) dest="/var/www/html/mod/data/field";; \
            dataformat) dest="/var/www/html/dataformat";; \
            datapreset) dest="/var/www/html/mod/data/preset";; \
            editor) dest="/var/www/html/lib/editor";; \
            enrol) dest="/var/www/html/enrol";; \
            fileconverter) dest="/var/www/html/files/converter";; \
            filter) dest="/var/www/html/filter";; \
            format) dest="/var/www/html/course/format";; \
            forumreport) dest="/var/www/html/mod/forum/report";; \
            gradeexport) dest="/var/www/html/grade/export";; \
            gradeimport) dest="/var/www/html/grade/import";; \
            gradereport) dest="/var/www/html/grade/report";; \
            gradingform) dest="/var/www/html/grade/grading/form";; \
            h5plib) dest="/var/www/html/h5p/h5plib";; \
            kaltura) dest="/var/www/html";; \
            lib) dest="/var/www/html/lib";; \
            local) dest="/var/www/html/local";; \
            logstore) dest="/var/www/html/admin/tool/log/store";; \
            ltiservice) dest="/var/www/html/mod/lti/service";; \
            ltisource) dest="/var/www/html/mod/lti/source";; \
            media) dest="/var/www/html/media/player";; \
            message) dest="/var/www/html/message/output";; \
            mlbackend) dest="/var/www/html/lib/mlbackend";; \
            mnetservice) dest="/var/www/html/mnet/service";; \
            mod) dest="/var/www/html/mod";; \
            plagiarism) dest="/var/www/html/plagiarism";; \
            portfolio) dest="/var/www/html/portfolio";; \
            profilefield) dest="/var/www/html/user/profile/field";; \
            qbank) dest="/var/www/html/question/bank";; \
            qbehaviour) dest="/var/www/html/question/behaviour";; \
            qformat) dest="/var/www/html/question/format";; \
            qtype) dest="/var/www/html/question/type";; \
            quiz) dest="/var/www/html/mod/quiz/report";; \
            quizaccess) dest="/var/www/html/mod/quiz/accessrule";; \
            report) dest="/var/www/html/report";; \
            repository) dest="/var/www/html/repository";; \
            scormreport) dest="/var/www/html/mod/scorm/report";; \
            search) dest="/var/www/html/search/engine";; \
            theme) dest="/var/www/html/theme";; \
            tool) dest="/var/www/html/admin/tool";; \
            webservice) dest="/var/www/html/webservice";; \
            workshopallocation) dest="/var/www/html/mod/workshop/allocation";; \
            workshopeval) dest="/var/www/html/mod/workshop/eval";; \
            workshopform) dest="/var/www/html/mod/workshop/form";; \
        esac; \
        \
        echo " → Installing into $dest"; \
        mkdir -p "$dest"; \
        unzip -q "$zip" -d "$dest"; \
        chown -R www-data:www-data "$dest"; \
    done; \
    rm -rf /plugins

COPY .htaccess /var/www/html/.htaccess
RUN chown www-data:www-data /var/www/html/.htaccess

COPY kalturapatch.sh /tmp/
RUN sh /tmp/kalturapatch.sh && rm /tmp/kalturapatch.sh

# Patch auth_saml2 to use SimpleSAMLphp's optional accessors. Catalyst's
# bundled SSP made getArray/getString/getBoolean/getLocalizedString strict —
# they now throw "Could not retrieve the required option ..." even when
# called with a default value. The plugin's intent (and the surrounding
# `if (!== NULL)` guards) show these reads were always meant to be optional.
# Without this:
#   - /auth/saml2/sp/metadata.php (View SP Metadata) blows up when an
#     authsource key like `description` is absent (locallib.php hunk).
#   - SAML signing/decryption flows can blow up reading
#     assertion.encryption / sharedKey / privatekey_pass etc. (vendor hunk).
#
# Mirrors upstream PR https://github.com/catalyst/moodle-auth_saml2/pull/915
# (still OPEN at the time of writing). The PR's vendor hunk has a typo
# (`getOptinalBoolean`, sic) on line 81; we use the correct
# `getOptionalBoolean` here.
RUN set -eux; \
    sed -i \
        -e "s|\$spconfig->getLocalizedString('name', NULL)|\$spconfig->getOptionalLocalizedString('name', NULL)|" \
        -e "s|\$spconfig->getArray('attributes', array())|\$spconfig->getOptionalArray('attributes', array())|" \
        -e "s|\$spconfig->getArray('attributes.required', array())|\$spconfig->getOptionalArray('attributes.required', array())|" \
        -e "s|\$spconfig->getArray('description', NULL)|\$spconfig->getOptionalArray('description', NULL)|" \
        -e "s|\$spconfig->getString('attributes.NameFormat', NULL)|\$spconfig->getOptionalString('attributes.NameFormat', NULL)|" \
        -e "s|\$spconfig->getLocalizedString('OrganizationName', NULL)|\$spconfig->getOptionalLocalizedString('OrganizationName', NULL)|" \
        -e "s|\$spconfig->getLocalizedString('OrganizationDisplayName', NULL)|\$spconfig->getOptionalLocalizedString('OrganizationDisplayName', NULL)|" \
        -e "s|\$spconfig->getLocalizedString('OrganizationURL', NULL)|\$spconfig->getOptionalLocalizedString('OrganizationURL', NULL)|" \
        -e "s|\$config->getString('technicalcontact_email', 'na@example.org', FALSE)|\$config->getOptionalString('technicalcontact_email', 'na@example.org')|" \
        -e "s|\$config->getString('technicalcontact_name', NULL)|\$config->getOptionalString('technicalcontact_name', NULL)|" \
        /var/www/html/auth/saml2/locallib.php; \
    find /var/www/html/auth/saml2 -name SimpleSAMLConverter.php -exec sed -i \
        -e "s|getBoolean('assertion.encryption', false)|getOptionalBoolean('assertion.encryption', false)|" \
        -e "s|getBoolean('base64attributes', false)|getOptionalBoolean('base64attributes', false)|" \
        -e "s|getString('sharedKey', null)|getOptionalString('sharedKey', null)|" \
        -e "s|getString('new_privatekey_pass', null)|getOptionalString('new_privatekey_pass', null)|" \
        -e "s|getString('privatekey_pass', null)|getOptionalString('privatekey_pass', null)|" \
        {} +; \
    chown -R www-data:www-data /var/www/html/auth/saml2
