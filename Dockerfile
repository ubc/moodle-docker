FROM php:7.4-apache
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>

ENV MOODLE_VERSION=3.9.20
ENV UPLOAD_MAX_FILESIZE=20M
ENV PHP_MEMORY_LIMIT=128M
ENV PHP_MAX_EXECUTION_TIME=30

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /var/www/html

RUN apt-get update \
    && apt-get -qq install graphviz aspell ghostscript libpspell-dev libpng-dev libicu-dev libxml2-dev libldap2-dev sudo netcat unzip libssl-dev zlib1g-dev libjpeg-dev libfreetype6-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) pspell gd intl xml xmlrpc ldap zip soap mysqli opcache \
    && pecl install redis \
    && docker-php-ext-enable redis \
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

RUN mkdir -p /var/www/html/admin/tool/heartbeat \
    && curl -L https://github.com/catalyst/moodle-tool_heartbeat/tarball/master | tar zx --strip-components=1 -C /var/www/html/admin/tool/heartbeat

VOLUME /moodledata
EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apachectl", "-e", "info", "-D", "FOREGROUND"]
