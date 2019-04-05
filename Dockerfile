FROM php:7.2-apache
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -qq install graphviz aspell ghostscript libpspell-dev libpng-dev libicu-dev libxml2-dev libldap2-dev sudo netcat unzip
RUN docker-php-ext-install -j$(nproc) pspell gd intl xml xmlrpc ldap zip soap mbstring mysqli opcache
RUN pecl install redis \
    && docker-php-ext-enable redis

RUN cd /var/www/html/
RUN curl -L https://github.com/moodle/moodle/archive/v3.6.3.tar.gz | tar xz --strip=1

RUN mkdir -p /moodledata /var/local/cache
RUN chown -R www-data /moodledata
RUN chmod -R 777 /moodledata /var/local/cache
RUN chmod -R 0755 /var/www/html

COPY config.php /var/www/html/
COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /moodledata
EXPOSE 80

RUN curl -L https://moodle.org/plugins/download.php/19255/theme_fordson_moodle36_2019111003.zip -o /fordson.zip \
    && cp /fordson.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip fordson.zip \
    && rm fordson.zip

RUN chown -R www-data /var/www/html

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apachectl", "-e", "info", "-D", "FOREGROUND"]
