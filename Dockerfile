FROM lthub/moodle:3.8.3
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>

RUN curl -L https://moodle.org/plugins/download.php/21849/mod_questionnaire_moodle39_2020011508.zip -o /questionnaire.zip \
    && cp /questionnaire.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip questionnaire.zip \
    && rm questionnaire.zip \

    && curl -L https://moodle.org/plugins/download.php/11565/mod_certificate_moodle33_2016052300.zip -o /certificate.zip \
    && cp /certificate.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip certificate.zip \
    && rm certificate.zip \

    && curl -L https://moodle.org/plugins/download.php/21208/mod_customcert_moodle38_2019111804.zip -o /customcert.zip \
    && cp /customcert.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip customcert.zip \
    && rm customcert.zip \

    && curl -L https://moodle.org/plugins/download.php/21001/mod_hvp_moodle39_2020020500.zip -o /hvp.zip \
    && cp /hvp.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip hvp.zip \
    && rm hvp.zip \

    && curl -L https://moodle.org/plugins/download.php/16906/block_poll_moodle37_2018052500.zip -o /poll.zip \
    && cp /poll.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip poll.zip \
    && rm poll.zip \

    && curl -L https://moodle.org/plugins/download.php/21871/report_customsql_moodle39_2020062800.zip -o /customsql.zip \
    && cp /customsql.zip /var/www/html/report/ \
    && cd /var/www/html/report \
    && unzip customsql.zip \
    && rm customsql.zip \

    && curl -L https://moodle.org/plugins/download.php/20641/format_grid_moodle38_2019111700.zip -o /grid.zip \
    && cp /grid.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip grid.zip \
    && rm grid.zip \

    && curl -L https://moodle.org/plugins/download.php/21512/format_flexsections_moodle38_2020051100.zip -o /flex.zip \
    && cp /flex.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip flex.zip \
    && rm flex.zip \

    && curl -L https://moodle.org/plugins/download.php/18183/mod_facetoface_moodle35_2018110900.zip -o /facetoface.zip \
    && cp /facetoface.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip facetoface.zip \
    && rm facetoface.zip \

    && curl -L https://moodle.org/plugins/download.php/14468/local_mass_enroll_moodle33_2015092402.zip -o /mass.zip \
    && cp /mass.zip /var/www/html/local/ \
    && cd /var/www/html/local \
    && unzip mass.zip \
    && rm mass.zip \

    && curl -L https://moodle.org/plugins/download.php/20585/block_course_modulenavigation_moodle38_2019052015.zip -o /modulenav.zip \
    && cp /modulenav.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip modulenav.zip \
    && rm modulenav.zip \
	
    && curl -L https://moodle.org/plugins/download.php/20829/block_configurable_reports_moodle38_2019122000.zip -o /configurable.zip \
    && cp /configurable.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip configurable.zip \
    && rm configurable.zip \

    && curl -L https://moodle.org/plugins/download.php/21289/local_boostnavigation_moodle37_2020040100.zip -o /boostnavig.zip \
    && cp /boostnavig.zip /var/www/html/local/ \
    && cd /var/www/html/local \
    && unzip boostnavig.zip \
    && rm boostnavig.zip 
	
# add custom cert
COPY certificate.php /var/www/html/mod/certificate/type/letter_non_embedded/

# add custom theme
COPY themes/maker-v5.1-moodle-3.8.zip /var/www/html/theme/ 
RUN cd /var/www/html/theme \
    && unzip maker-v5.1-moodle-3.8.zip \
    && rm maker-v5.1-moodle-3.8.zip

# add custom font
COPY fonts /var/www/html/theme/maker/fonts
	
RUN chown -R www-data /var/www/html
