FROM lthub/moodle:moodlecore-4.1LTS
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>


RUN curl -L https://moodle.org/plugins/download.php/26900/mod_questionnaire_moodle40_2021062301.zip -o /questionnaire.zip \
    && cp /questionnaire.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip questionnaire.zip \
    && rm questionnaire.zip \ 

#This is the latest version of plugin moodle33 as of 20Dec2022
    && curl -L https://moodle.org/plugins/download.php/11565/mod_certificate_moodle33_2016052300.zip -o /certificate.zip \
    && cp /certificate.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip certificate.zip \
    && rm certificate.zip \

    && curl -L https://moodle.org/plugins/download.php/28179/mod_hvp_moodle41_2022121200.zip -o /hvp.zip \
    && cp /hvp.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip hvp.zip \
    && rm hvp.zip \ 

#This is the latest version: And pending on Kate verification with her team.
    && curl -L https://moodle.org/plugins/download.php/16906/block_poll_moodle37_2018052500.zip -o /poll.zip \
    && cp /poll.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip poll.zip \
    && rm poll.zip \

    && curl -L https://moodle.org/plugins/download.php/26177/report_customsql_moodle40_2022031800.zip -o /customsql.zip \
    && cp /customsql.zip /var/www/html/report/ \
    && cd /var/www/html/report \
    && unzip customsql.zip \
    && rm customsql.zip \ 

    && curl -L https://moodle.org/plugins/download.php/28049/format_grid_moodle41_2022112600.zip -o /grid.zip \
    && cp /grid.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip grid.zip \
    && rm grid.zip \
 
    && curl -L https://moodle.org/plugins/download.php/26868/format_flexsections_moodle40_2022061900.zip -o /flex.zip \
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
#This is the last version of this plugin for moodle33 as of 20Dec2022: 
    && curl -L https://moodle.org/plugins/download.php/14468/local_mass_enroll_moodle33_2015092402.zip -o /mass.zip \
    && cp /mass.zip /var/www/html/local/ \
    && cd /var/www/html/local \
    && unzip mass.zip \
    && rm mass.zip \

    && curl -L https://moodle.org/plugins/download.php/28180/block_course_modulenavigation_moodle41_2022121300.zip -o /modulenav.zip \
    && cp /modulenav.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip modulenav.zip \
    && rm modulenav.zip \ 

#This is the latest version of this plugin for moodle310 as of 11Jan2023:
    && curl -L https://moodle.org/plugins/download.php/22758/block_configurable_reports_moodle310_2020110300.zip -o /configurable.zip \
    && cp /configurable.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip configurable.zip \
    && rm configurable.zip \


    && curl -L https://moodle.org/plugins/download.php/27010/local_boostnavigation_moodle311_2021071501.zip -o /boostnavig.zip \
    && cp /boostnavig.zip /var/www/html/local/ \
    && cd /var/www/html/local \
    && unzip boostnavig.zip \
    && rm boostnavig.zip \ 


    && curl -L https://moodle.org/plugins/download.php/24764/tool_mergeusers_moodle311_2021072200.zip -o /mergeuser.zip \
    && cp /mergeuser.zip /var/www/html/admin/tool/ \
    && cd /var/www/html/admin/tool \
    && unzip mergeuser.zip \
    && rm mergeuser.zip \ 

    && curl -L https://moodle.org/plugins/download.php/22662/filter_multilang2_moodle40_2020101300.zip -o /multi.zip \
    && cp /multi.zip /var/www/html/filter/ \
    && cd /var/www/html/filter \
    && unzip multi.zip \
    && rm multi.zip \

    && curl -L https://moodle.org/plugins/download.php/26482/availability_language_moodle41_2022041900.zip -o /avail.zip \
    && cp /avail.zip /var/www/html/availability/condition/ \
    && cd /var/www/html/availability/condition \
    && unzip avail.zip \
    && rm avail.zip \

#Pending on Kate verification with her team.
    && curl -L https://moodle.org/plugins/download.php/27505/block_panopto_moodle40_2022090700.zip -o /panopto.zip \
    && cp /panopto.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip panopto.zip \
    && rm panopto.zip \

    && curl -L https://moodle.org/plugins/download.php/27445/local_recompletion_moodle40_2022082900.zip -o /recomplete.zip \
    && cp /recomplete.zip /var/www/html/local/ \
    && cd /var/www/html/local \
    && unzip recomplete.zip \
    && rm recomplete.zip 


#This is the latest version of this plugin moodle311 - checked again on 11Jan2023 16:38: 
#ARLO plugin requires Arlo_connection setting.
#    && curl -L https://moodle.org/plugins/download.php/27469/enrol_arlo_moodle311_2022090100.zip -o /enrolarlo.zip \
#    && cp /enrolarlo.zip /var/www/html/enrol/ \
#    && cd /var/www/html/enrol \
#    && unzip enrolarlo.zip \
#    && rm enrolarlo.zip


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

RUN chmod -R 755 /docker-entrypoint.d/
