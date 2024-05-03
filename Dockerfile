##FROM lthub/moodle:moodlecore-4.1LTS
##FROM dangtue2020/moodlecore:419stg2-bb4b231d8e23
##FROM dangtue2020/moodlecore:419stg2-7f3ef6e86ac4
FROM dangtue2020/moodlecore:419stg2-41ec0380b10f


#Updated to newer questionnaire 10Dec2023
RUN curl -L https://moodle.org/plugins/download.php/29228/mod_questionnaire_moodle42_2022092202.zip -o /questionnaire.zip \
    && cp /questionnaire.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip questionnaire.zip \
    && rm questionnaire.zip \ 

#This is the latest version of plugin moodle33 as of 20Dec2022 and 11Dec2023
    && curl -L https://moodle.org/plugins/download.php/11565/mod_certificate_moodle33_2016052300.zip -o /certificate.zip \
    && cp /certificate.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip certificate.zip \
    && rm certificate.zip \

#Updated to newer hvp 10Dec2023 and 18Apr2024
    && curl -L https://moodle.org/plugins/download.php/30739/mod_hvp_moodle43_2023122500.zip -o /hvp.zip \
    && cp /hvp.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip hvp.zip \
    && rm hvp.zip \ 

#This is the latest version: And pending on Kate verification with her team.
#This is the latest version of plugin moodle33 as of 11Dec2023
    && curl -L https://moodle.org/plugins/download.php/16906/block_poll_moodle37_2018052500.zip -o /poll.zip \
    && cp /poll.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip poll.zip \
    && rm poll.zip \

#This is the latest version of plugin moodle31 as of 11Dec2023
    && curl -L https://moodle.org/plugins/download.php/26177/report_customsql_moodle40_2022031800.zip -o /customsql.zip \
    && cp /customsql.zip /var/www/html/report/ \
    && cd /var/www/html/report \
    && unzip customsql.zip \
    && rm customsql.zip \ 

#Updated as of 11Dec2023 and 18Apr2024
    && curl -L https://moodle.org/plugins/download.php/31635/format_grid_moodle41_2022112609.zip -o /grid.zip \
    && cp /grid.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip grid.zip \
    && rm grid.zip \
 
 #Updated as of 11Dec2023 and 18Apr2024
    && curl -L https://moodle.org/plugins/download.php/30735/format_flexsections_moodle43_2023122300.zip -o /flex.zip \
    && cp /flex.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip flex.zip \
    && rm flex.zip \ 

# Kate requested to remove:
#    && curl -L https://moodle.org/plugins/download.php/25559/mod_facetoface_moodle311_2021113000.zip -o /facetoface.zip \
#    && cp /facetoface.zip /var/www/html/mod/ \
#    && cd /var/www/html/mod \
#    && unzip facetoface.zip \
#    && rm facetoface.zip \ 
#

#Updated as of 11Dec2023
    && curl -L https://moodle.org/plugins/download.php/30331/local_mass_enroll_moodle43_2023102300.zip -o /mass.zip \
    && cp /mass.zip /var/www/html/local/ \
    && cd /var/www/html/local \
    && unzip mass.zip \
    && rm mass.zip \

#Updated as of 11Dec2023
    && curl -L https://moodle.org/plugins/download.php/30267/block_course_modulenavigation_moodle43_2023101700.zip -o /modulenav.zip \
    && cp /modulenav.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip modulenav.zip \
    && rm modulenav.zip \ 

#This is the latest version of this plugin for moodle310 as of 11Jan2023 and 11Dec2023: 
    && curl -L https://moodle.org/plugins/download.php/22758/block_configurable_reports_moodle310_2020110300.zip -o /configurable.zip \
    && cp /configurable.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip configurable.zip \
    && rm configurable.zip \

#No change as of 11Dec2023
    && curl -L https://moodle.org/plugins/download.php/27010/local_boostnavigation_moodle311_2021071501.zip -o /boostnavig.zip \
    && cp /boostnavig.zip /var/www/html/local/ \
    && cd /var/www/html/local \
    && unzip boostnavig.zip \
    && rm boostnavig.zip \ 

    && curl -L https://moodle.org/plugins/download.php/28943/tool_mergeusers_moodle41_2023040402.zip -o /mergeuser.zip \
    && cp /mergeuser.zip /var/www/html/admin/tool/ \
    && cd /var/www/html/admin/tool \
    && unzip mergeuser.zip \
    && rm mergeuser.zip \ 

#Updated as of 11Dec2023 and 18Apr2024
    && curl -L https://moodle.org/plugins/download.php/31000/filter_multilang2_moodle43_2024013101.zip -o /multi.zip \
    && cp /multi.zip /var/www/html/filter/ \
    && cd /var/www/html/filter \
    && unzip multi.zip \
    && rm multi.zip \

#Updated as of 11Dec2023
    && curl -L https://moodle.org/plugins/download.php/30198/availability_language_moodle43_2023101400.zip -o /avail.zip \
    && cp /avail.zip /var/www/html/availability/condition/ \
    && cd /var/www/html/availability/condition \
    && unzip avail.zip \
    && rm avail.zip \

#Pending on Kate verification with her team.
#Updated as of 11Dec2023
    && curl -L https://moodle.org/plugins/download.php/29980/block_panopto_moodle42_2023091800.zip -o /panopto.zip \
    && cp /panopto.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip panopto.zip \
    && rm panopto.zip \

#Updated as of 11Dec2023 and 18Apr2024
    && curl -L https://moodle.org/plugins/download.php/31207/local_recompletion_moodle42_2023112702.zip -o /recomplete.zip \
    && cp /recomplete.zip /var/www/html/local/ \
    && cd /var/www/html/local \
    && unzip recomplete.zip \
    && rm recomplete.zip \

#This is the latest version of this plugin ARLO v4.1.4 - checked again on 23Jan2024 12:38: 
#ARLO plugin requires Arlo_connection setting.
    && curl -L https://moodle.org/plugins/download.php/30634/enrol_arlo_moodle42_2023110900.zip -o /enrolarlo.zip \
    && cp /enrolarlo.zip /var/www/html/enrol/ \
    && cd /var/www/html/enrol \
    && unzip enrolarlo.zip \
    && rm enrolarlo.zip


# add custom cert
COPY certificate.php /var/www/html/mod/certificate/type/letter_non_embedded/

# add custom moove theme
COPY themes/moove_premium.zip /var/www/html/theme/
RUN cd /var/www/html/theme \
    && unzip moove_premium.zip \
    && rm moove_premium.zip 

# add custom theme
COPY themes/maker-v10.0-moodle-4.1.zip /var/www/html/theme/
RUN cd /var/www/html/theme \
    && unzip maker-v10.0-moodle-4.1.zip \
    && rm maker-v10.0-moodle-4.1.zip 

# add tinymce for panopto
COPY plugin/panoptobutton.zip /var/www/html/lib/editor/tinymce/plugins/

RUN cd /var/www/html/lib/editor/tinymce/plugins/ \
    && unzip panoptobutton.zip \
    && rm panoptobutton.zip

# add new config file for mergeusers plugin
COPY plugin/config.local.php /var/www/html/admin/tool/mergeusers/config/


RUN cd /var/www/html/theme/maker/pix/ \
    && rm favicon.ico

COPY themes/favicon.ico /var/www/html/theme/maker/pix/

# add favicon to moove
COPY themes/favicon.ico /var/www/html/theme/moove/pix/

# add custom font
COPY fonts /var/www/html/theme/maker/fonts

# add custom font to moove
COPY fonts /var/www/html/theme/moove/fonts

RUN chown -R www-data /var/www/html

# install odbc for shib sp
RUN apt-get update && \
    apt-get -y install unixodbc libapache2-mod-shib gettext && \
    cd /usr && \
    curl https://downloads.mariadb.com/Connectors/odbc/connector-odbc-3.1.1/mariadb-connector-odbc-3.1.1-ga-debian-x86_64.tar.gz | tar -xvz && \
    echo "[MariaDB]" > MariaDB_odbc_driver_template.ini && \
    echo "Description = MariaDB Connector/ODBC v.3.1" >> MariaDB_odbc_driver_template.ini && \
    echo "Driver = /usr/lib/libmaodbc.so" >> MariaDB_odbc_driver_template.ini && \
    odbcinst -i -d -f MariaDB_odbc_driver_template.ini

COPY shibboleth2.xml-template /etc/shibboleth/
COPY moodle-shib.conf /etc/apache2/conf-enabled/
COPY docker-entrypoint.d/* /docker-entrypoint.d/
COPY 000-default.conf /etc/apache2/sites-available/

# add modified files for Language Icon
COPY themes/maker-header.mustache /var/www/html/theme/maker/templates/header.mustache
COPY themes/boost-language_menu.mustache /var/www/html/theme/boost/templates/language_menu.mustache
COPY themes/updated-icon-designs-4.1/mod/ /var/www/html/theme/maker/pix_plugins/mod

COPY themes/updated-icon-designs-4.1/core/f/ /var/www/html/pix/f/


RUN sleep 3 && echo "\$THEME->removedprimarynavitems = ['courses'];" >> /var/www/html/theme/maker/config.php
##RUN sleep 3 && sed -i "\$a\\n\\n\$THEME->removedprimarynavitems = ['courses'];" /var/www/html/theme/maker/config.php

RUN chmod -R 755 /docker-entrypoint.d/
