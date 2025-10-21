FROM lthub/moodle:4.5.7
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>

# https://moodle.org/plugins/mod_questionnaire
RUN curl -L https://moodle.org/plugins/download.php/33023/mod_questionnaire_moodle44_2022121601.zip -o /questionnaire.zip \
    && echo "--- FILE TYPE ---" \
    && cat /questionnaire.zip \
    && echo "--- HEAD OF FILE ---" \
    && cp /questionnaire.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip questionnaire.zip \
    && rm questionnaire.zip

# https://moodle.org/plugins/mod_certificate
RUN curl -L https://moodle.org/plugins/download.php/11565/mod_certificate_moodle33_2016052300.zip -o /certificate.zip \
    && cp /certificate.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip certificate.zip \
    && rm certificate.zip
	
# https://moodle.org/plugins/mod_hvp
RUN curl -L https://moodle.org/plugins/download.php/34151/mod_hvp_moodle45_2024120900.zip -o /hvp.zip \
    && cp /hvp.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip hvp.zip \
    && rm hvp.zip

# https://moodle.org/plugins/report_customsql
RUN curl -L https://moodle.org/plugins/download.php/26177/report_customsql_moodle40_2022031800.zip -o /customsql.zip \
    && cp /customsql.zip /var/www/html/report/ \
    && cd /var/www/html/report \
    && unzip customsql.zip \
    && rm customsql.zip

# https://moodle.org/plugins/format_grid
RUN curl -L https://moodle.org/plugins/download.php/37815/format_grid_moodle45_2024101508.zip -o /grid.zip \
    && cp /grid.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip grid.zip \
    && rm grid.zip

# https://moodle.org/plugins/format_flexsections
RUN curl -L https://moodle.org/plugins/download.php/36158/format_flexsections_moodle45_2024120801.zip -o /flex.zip \
    && cp /flex.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip flex.zip \
    && rm flex.zip

# https://moodle.org/plugins/local_mass_enroll
RUN curl -L https://moodle.org/plugins/download.php/34306/local_mass_enroll_moodle45_2024121600.zip -o /mass.zip \
    && cp /mass.zip /var/www/html/local/ \
    && cd /var/www/html/local \
    && unzip mass.zip \
    && rm mass.zip

# https://moodle.org/plugins/block_course_modulenavigation
RUN curl -L https://moodle.org/plugins/download.php/33478/block_course_modulenavigation_moodle45_2024101401.zip -o /modulenav.zip \
    && cp /modulenav.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip modulenav.zip \
    && rm modulenav.zip

# https://moodle.org/plugins/tool_mergeusers
RUN curl -L https://moodle.org/plugins/download.php/38323/tool_mergeusers_moodle51_2025102100.zip -o /mergeuser.zip \
    && cp /mergeuser.zip /var/www/html/admin/tool/ \
    && cd /var/www/html/admin/tool \
    && unzip mergeuser.zip \
    && rm mergeuser.zip

# https://moodle.org/plugins/filter_multilang2
RUN curl -L https://moodle.org/plugins/download.php/35750/filter_multilang2_moodle50_2025041701.zip -o /multi.zip \
    && cp /multi.zip /var/www/html/filter/ \
    && cd /var/www/html/filter \
    && unzip multi.zip \
    && rm multi.zip

# https://moodle.org/plugins/availability_language
RUN curl -L https://moodle.org/plugins/download.php/33331/availability_language_moodle45_2024100700.zip -o /avail.zip \
    && cp /avail.zip /var/www/html/availability/condition/ \
    && cd /var/www/html/availability/condition \
    && unzip avail.zip \
    && rm avail.zip

# https://moodle.org/plugins/local_recompletion
RUN curl -L https://moodle.org/plugins/download.php/35657/local_recompletion_moodle45_2025041400.zip -o /recomplete.zip \
    && cp /recomplete.zip /var/www/html/local/ \
    && cd /var/www/html/local \
    && unzip recomplete.zip \
    && rm recomplete.zip

# https://moodle.org/plugins/mod_subcourse
RUN curl -L https://moodle.org/plugins/download.php/35371/mod_subcourse_moodle45_2025032000.zip -o /subcourse.zip \
    && cp /subcourse.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip subcourse.zip \
    && rm subcourse.zip

# https://moodle.org/plugins/mod_zoom
RUN curl -L https://moodle.org/plugins/download.php/38270/mod_zoom_moodle51_2025101600.zip -o /zoom.zip \
    && cp /zoom.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip zoom.zip \
    && rm zoom.zip

# https://moodle.org/plugins/mod_customcert
RUN curl -L https://moodle.org/plugins/download.php/36496/mod_customcert_moodle45_2024042212.zip -o /customcertificate.zip \
    && cp /customcertificate.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip customcertificate.zip \
    && rm customcertificate.zip

# add custom cert
COPY certificate.php /var/www/html/mod/certificate/type/letter_non_embedded/

# add custom theme
COPY themes/maker-v14.2-moodle-4.5.zip /var/www/html/theme/
RUN cd /var/www/html/theme \
    && unzip maker-v14.2-moodle-4.5.zip \
    && rm maker-v14.2-moodle-4.5.zip 

RUN mkdir -p /var/www/html/enrol/arlo \
    && curl -L https://github.com/ArloSoftware/moodle-enrol_arlo/tarball/V4.2.2 | tar zx --strip-components=1 -C /var/www/html/enrol/arlo
	
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

# supress "your site not registered" message
RUN sed -i 's|echo $adminrenderer->warn_if_not_registered();|//echo $adminrenderer->warn_if_not_registered();|g' /var/www/html/admin/search.php 

RUN sleep 3 && echo "\$THEME->removedprimarynavitems = ['courses'];" >> /var/www/html/theme/maker/config.php

RUN chmod -R 755 /docker-entrypoint.d/
