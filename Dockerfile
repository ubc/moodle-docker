FROM php:7.2-apache
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get -qq install graphviz aspell ghostscript libpspell-dev libpng-dev libicu-dev libxml2-dev libldap2-dev sudo netcat
RUN docker-php-ext-install -j$(nproc) pspell gd intl xml xmlrpc ldap zip soap mbstring mysqli opcache

RUN cd /var/www/html/
RUN curl -L https://github.com/moodle/moodle/archive/v3.6.3.tar.gz | tar xz --strip=1

RUN mkdir /moodledata
RUN chown -R www-data /moodledata
RUN chmod -R 777 /moodledata
RUN chmod -R 0755 /var/www/html

COPY config.php /var/www/html/
COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME /moodledata
EXPOSE 80

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apachectl", "-e", "info", "-D", "FOREGROUND"]
