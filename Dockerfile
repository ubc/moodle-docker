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
	
RUN curl -L https://moodle.org/plugins/download.php/19206/mod_questionnaire_moodle36_2018050109.zip -o /questionnaire.zip \
    && cp /questionnaire.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip questionnaire.zip \
    && rm questionnaire.zip
	
RUN curl -L https://moodle.org/plugins/download.php/19208/block_xp_moodle36_2019032102.zip -o /xp.zip \
    && cp /xp.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip xp.zip \
    && rm xp.zip
	
RUN curl -L https://moodle.org/plugins/download.php/16327/format_socialwall_moodle33_2018030700.zip -o /socialwall.zip \
    && cp /socialwall.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip socialwall.zip \
    && rm socialwall.zip
	
RUN curl -L https://moodle.org/plugins/download.php/19238/format_topcoll_moodle36_2018121901.zip -o /topcoll.zip \
    && cp /topcoll.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip topcoll.zip \
    && rm topcoll.zip

RUN curl -L https://moodle.org/plugins/download.php/19255/theme_fordson_moodle36_2019111003.zip -o /fordson.zip \
    && cp /fordson.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip fordson.zip \
    && rm fordson.zip
		
RUN curl -L https://moodle.org/plugins/download.php/19061/mod_attendance_moodle36_2019022500.zip -o /attendance.zip \
    && cp /attendance.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip attendance.zip \
    && rm attendance.zip
	
RUN curl -L https://moodle.org/plugins/download.php/14021/block_accessibility_moodle31_2017051700.zip -o /accessibility.zip \
    && cp /accessibility.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip accessibility.zip \
    && rm accessibility.zip
	
RUN curl -L https://moodle.org/plugins/download.php/19296/qtype_multichoiceset_moodle36_2019040501.zip -o /multichoiceset.zip \
    && cp /multichoiceset.zip /var/www/html/question/type/ \
    && cd /var/www/html/question/type \
    && unzip multichoiceset.zip \
    && rm multichoiceset.zip
	
RUN curl -L https://moodle.org/plugins/download.php/18171/enrol_autoenrol_moodle36_2018101902.zip -o /autoenrol.zip \
    && cp /autoenrol.zip /var/www/html/enrol/ \
    && cd /var/www/html/enrol \
    && unzip autoenrol.zip \
    && rm autoenrol.zip
	
RUN curl -L https://moodle.org/plugins/download.php/17251/format_buttons_moodle35_2018062700.zip -o /buttons.zip \
    && cp /buttons.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip buttons.zip \
    && rm buttons.zip

RUN curl -L https://moodle.org/plugins/download.php/19083/theme_moove_moodle36_2019022800.zip -o /moove.zip \
    && cp /moove.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip moove.zip \
    && rm moove.zip

RUN curl -L https://moodle.org/plugins/download.php/18461/theme_waxed_moodle36_2018120500.zip -o /waxed.zip \
    && cp /waxed.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip waxed.zip \
    && rm waxed.zip
	
RUN curl -L https://moodle.org/plugins/download.php/17344/mod_choicegroup_moodle35_2018070900.zip -o /choicegroup.zip \
    && cp /choicegroup.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip choicegroup.zip \
    && rm choicegroup.zip
	
RUN curl -L https://moodle.org/plugins/download.php/18183/mod_facetoface_moodle35_2018110900.zip -o /facetoface.zip \
    && cp /facetoface.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip facetoface.zip \
    && rm facetoface.zip
	
RUN curl -L https://moodle.org/plugins/download.php/18351/mod_scheduler_moodle36_2018112600.zip -o /scheduler.zip \
    && cp /scheduler.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip scheduler.zip \
    && rm scheduler.zip
	
RUN curl -L https://moodle.org/plugins/download.php/18988/block_configurable_reports_moodle36_2019021500.zip -o /configurable.zip \
    && cp /configurable.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip configurable.zip \
    && rm configurable.zip
	
RUN chown -R www-data /var/www/html

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apachectl", "-e", "info", "-D", "FOREGROUND"]
