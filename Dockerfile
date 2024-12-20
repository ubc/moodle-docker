FROM lthub/moodle:4.1.15-php8.1
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>

RUN curl -L https://moodle.org/plugins/download.php/33023/mod_questionnaire_moodle44_2022121601.zip -o /questionnaire.zip \
    && cp /questionnaire.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip questionnaire.zip \
    && rm questionnaire.zip \ 

    && curl -L https://moodle.org/plugins/download.php/11565/mod_certificate_moodle33_2016052300.zip -o /certificate.zip \
    && cp /certificate.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip certificate.zip \
    && rm certificate.zip \

    && curl -L https://moodle.org/plugins/download.php/33143/mod_hvp_moodle44_2024091200.zip -o /hvp.zip \
    && cp /hvp.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip hvp.zip \
    && rm hvp.zip \ 

    && curl -L https://moodle.org/plugins/download.php/26177/report_customsql_moodle40_2022031800.zip -o /customsql.zip \
    && cp /customsql.zip /var/www/html/report/ \
    && cd /var/www/html/report \
    && unzip customsql.zip \
    && rm customsql.zip \ 

    && curl -L https://moodle.org/plugins/download.php/31635/format_grid_moodle41_2022112609.zip -o /grid.zip \
    && cp /grid.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip grid.zip \
    && rm grid.zip \
 
    && curl -L https://moodle.org/plugins/download.php/33307/format_flexsections_moodle45_2024100600.zip -o /flex.zip \
    && cp /flex.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip flex.zip \
    && rm flex.zip \ 

    && curl -L https://moodle.org/plugins/download.php/30267/block_course_modulenavigation_moodle43_2023101700.zip -o /modulenav.zip \
    && cp /modulenav.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip modulenav.zip \
    && rm modulenav.zip \ 

    && curl -L https://moodle.org/plugins/download.php/33800/block_configurable_reports_moodle45_2024051300.zip -o /configurable.zip \
    && cp /configurable.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip configurable.zip \
    && rm configurable.zip \

    && curl -L https://moodle.org/plugins/download.php/28943/tool_mergeusers_moodle41_2023040402.zip -o /mergeuser.zip \
    && cp /mergeuser.zip /var/www/html/admin/tool/ \
    && cd /var/www/html/admin/tool \
    && unzip mergeuser.zip \
    && rm mergeuser.zip \ 

    && curl -L https://moodle.org/plugins/download.php/34033/filter_multilang2_moodle45_2024112701.zip -o /multi.zip \
    && cp /multi.zip /var/www/html/filter/ \
    && cd /var/www/html/filter \
    && unzip multi.zip \
    && rm multi.zip \

    && curl -L https://moodle.org/plugins/download.php/30198/availability_language_moodle43_2023101400.zip -o /avail.zip \
    && cp /avail.zip /var/www/html/availability/condition/ \
    && cd /var/www/html/availability/condition \
    && unzip avail.zip \
    && rm avail.zip \

    && curl -L https://moodle.org/plugins/download.php/31207/local_recompletion_moodle42_2023112702.zip -o /recomplete.zip \
    && cp /recomplete.zip /var/www/html/local/ \
    && cd /var/www/html/local \
    && unzip recomplete.zip \
    && rm recomplete.zip
	
# add custom cert
COPY certificate.php /var/www/html/mod/certificate/type/letter_non_embedded/

# add custom theme
COPY themes/maker-v10.0-moodle-4.1.zip /var/www/html/theme/
RUN cd /var/www/html/theme \
    && unzip maker-v10.0-moodle-4.1.zip \
    && rm maker-v10.0-moodle-4.1.zip 

RUN mkdir -p /var/www/html/enrol/arlo \
    && curl -L https://github.com/ArloSoftware/moodle-enrol_arlo/tarball/v4.2.0 | tar zx --strip-components=1 -C /var/www/html/enrol/arlo
	
# add new config file for mergeusers plugin
COPY plugin/config.local.php /var/www/html/admin/tool/mergeusers/config/

RUN cd /var/www/html/theme/maker/pix/ \
    && rm favicon.ico

COPY themes/favicon.ico /var/www/html/theme/maker/pix/

# add custom font
COPY fonts /var/www/html/theme/maker/fonts

RUN chown -R www-data /var/www/html

# install odbc for shib sp
RUN apt-get update && \
    apt-get -y install unixodbc odbcinst libapache2-mod-shib gettext && \
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

##COPY themes/lib/outputrenderers.php /var/www/html/lib/
RUN sed -i.bak '/public function lang_menu/ i\ public function get_language() {return current_language();}\n' /var/www/html/lib/outputrenderers.php

RUN sleep 3 && echo "\$THEME->removedprimarynavitems = ['courses'];" >> /var/www/html/theme/maker/config.php

RUN chmod -R 755 /docker-entrypoint.d/