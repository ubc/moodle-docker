# syntax=docker/dockerfile:1.7
FROM php:8.3-apache
LABEL maintainer="Tyler Cinkant <tyler.cinkant@ubc.ca>"

ENV UPLOAD_MAX_FILESIZE=20M
ENV PHP_MEMORY_LIMIT=128M
ENV PHP_MAX_EXECUTION_TIME=30
ENV PHP_MAX_INPUT_VARS=6000

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /var/www/html

# Layer 1 (stable across Moodle bumps): runtime tools, PHP extensions, pecl redis.
# Dev/-dev packages are purged after compilation via the savedAptMark pattern:
# runtime libs needed by the compiled .so files are discovered with ldd and
# re-marked manual, then apt-get autoremove drops the build-only headers.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    set -eux; \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    apt-get update; \
    # Runtime tools used by Moodle / entrypoint at runtime — kept in final image.
    apt-get install -y --no-install-recommends \
        graphviz aspell ghostscript sudo netcat-traditional unzip; \
    # Snapshot manual-mark BEFORE installing -dev packages so they're preserved.
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get install -y --no-install-recommends \
        libpspell-dev libpng-dev libicu-dev libxml2-dev libldap2-dev \
        libssl-dev zlib1g-dev libjpeg-dev libfreetype6-dev libzip-dev; \
    docker-php-ext-configure gd --with-freetype --with-jpeg; \
    docker-php-ext-install -j"$(nproc)" pspell gd intl xml ldap zip soap mysqli opcache exif; \
    pecl install redis && docker-php-ext-enable redis; \
    # Auto-mark everything, restore the runtime-tool manual list, then re-mark
    # any shared lib pulled in by a compiled extension so it survives autoremove.
    apt-mark auto '.*' > /dev/null; \
    [ -z "$savedAptMark" ] || apt-mark manual $savedAptMark; \
    find /usr/local -type f -executable -exec ldd '{}' ';' 2>/dev/null \
      | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); print so }' \
      | sort -u \
      | xargs -r dpkg-query -S 2>/dev/null \
      | grep -v '^diversion by ' \
      | cut -d: -f1 \
      | sort -u \
      | xargs -r apt-mark manual; \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Layer 2 (stable): OPcache config.
# Sized for Moodle 4.5 (~15k PHP files). validate_timestamps=0 is safe because
# this image is immutable — each new release rebuilds and restarts the pod, which
# resets OPcache automatically. JIT in PHP 8.3 defaults to tracing mode but
# requires an explicit jit_buffer_size to actually allocate; without it JIT is
# enabled in name only.
RUN { \
        echo 'opcache.memory_consumption=384'; \
        echo 'opcache.interned_strings_buffer=32'; \
        echo 'opcache.max_accelerated_files=24000'; \
        echo 'opcache.validate_timestamps=0'; \
        echo 'opcache.jit=tracing'; \
        echo 'opcache.jit_buffer_size=128M'; \
     } > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Layer 3 (stable): Apache modules + remoteip + client-IP-aware LogFormat.
RUN set -eux; \
    a2enmod rewrite expires remoteip; \
    { \
        echo 'RemoteIPHeader X-Forwarded-For'; \
        echo 'RemoteIPTrustedProxy 10.0.0.0/8'; \
        echo 'RemoteIPTrustedProxy 172.16.0.0/12'; \
        echo 'RemoteIPTrustedProxy 192.168.0.0/16'; \
        echo 'RemoteIPTrustedProxy 169.254.0.0/16'; \
        echo 'RemoteIPTrustedProxy 127.0.0.0/8'; \
     } > /etc/apache2/conf-available/remoteip.conf; \
    a2enconf remoteip; \
# https://github.com/docker-library/wordpress/issues/383#issuecomment-507886512
# (replace all instances of "%h" with "%a" in LogFormat)
    find /etc/apache2 -type f -name '*.conf' -exec sed -ri 's/([[:space:]]*LogFormat[[:space:]]+"[^"]*)%h([^"]*")/\1%a\2/g' '{}' +

# Layer 4 (volatile): Moodle source. Isolated so MOODLE_VERSION bumps don't
# invalidate the apt/extensions layers above.
ARG MOODLE_VERSION=4.5.12
ENV MOODLE_VERSION=${MOODLE_VERSION}
RUN set -eux; \
    curl -fL "https://github.com/moodle/moodle/archive/v${MOODLE_VERSION}.tar.gz" | tar xz --strip=1; \
    mkdir -p /moodledata /var/local/cache /docker-entrypoint.d; \
    chmod -R 0755 /var/www/html; \
    chmod 0777 /moodledata /var/local/cache; \
    chown -R www-data:www-data /var/www/html /moodledata

# Drop-in config and entrypoint. --chown avoids a follow-up recursive chown.
COPY --chown=www-data:www-data config.php register-redis-cache-store.php /var/www/html/
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY custom-php.ini $PHP_INI_DIR/conf.d/

# Plugins: extract each plugins/<type>_<name>_<version>.zip into the Moodle
# subtree the type expects, then chown only the destination (avoids a global
# recursive chown of /var/www/html in a second layer).
COPY plugins/ /plugins/
RUN set -eux; \
    cd /plugins; \
	set -- *.zip; [ -e "$1" ] || set --;\
    for zip in "$@"; do \
        echo "Processing $zip..."; \
        type="${zip%%_*}"; \
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

VOLUME /moodledata
EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apachectl", "-e", "info", "-D", "FOREGROUND"]
