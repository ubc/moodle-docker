FROM php:8.3-apache
LABEL maintainer="Tyler Cinkant <tyler.cinkant@ubc.ca>"

ENV MOODLE_VERSION=4.5.8
ENV UPLOAD_MAX_FILESIZE=20M
ENV PHP_MEMORY_LIMIT=128M
ENV PHP_MAX_EXECUTION_TIME=30
ENV PHP_MAX_INPUT_VARS=6000

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /var/www/html

RUN apt-get update \
    && apt-get -qq install graphviz aspell ghostscript libpspell-dev libpng-dev libicu-dev libxml2-dev libldap2-dev sudo netcat-traditional unzip libssl-dev zlib1g-dev libjpeg-dev libfreetype6-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) pspell gd intl xml ldap zip soap mysqli opcache exif \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && docker-php-ext-enable exif \
    && curl -L https://github.com/moodle/moodle/archive/v${MOODLE_VERSION}.tar.gz | tar xz --strip=1 \
    && mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" \
    && mkdir -p /moodledata /var/local/cache \
    && chown -R www-data /moodledata \
    && chmod -R 777 /moodledata /var/local/cache \
    && chmod -R 0755 /var/www/html \
    && chown -R www-data /var/www/html \
    && mkdir /docker-entrypoint.d

# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.fast_shutdown=1'; \
     } > /usr/local/etc/php/conf.d/opcache-recommended.ini

RUN set -eux; \
    a2enmod rewrite expires; \
    \
# https://httpd.apache.org/docs/2.4/mod/mod_remoteip.html
    a2enmod remoteip; \
    { \
        echo 'RemoteIPHeader X-Forwarded-For'; \
# these IP ranges are reserved for "private" use and should thus *usually* be safe inside Docker
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

COPY config.php /var/www/html/
COPY docker-entrypoint.sh /docker-entrypoint.sh
COPY custom-php.ini $PHP_INI_DIR/conf.d/

# Fetching and unzipping all plugins
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
    done; \
    rm -rf /plugins

RUN chown -R www-data /var/www/html

VOLUME /moodledata
EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apachectl", "-e", "info", "-D", "FOREGROUND"]
