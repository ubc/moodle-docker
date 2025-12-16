FROM lthub/moodle:4.5.8
LABEL maintainer="Tyler Cinkant <tyler.cinkant@ubc.ca>"

# Fetching and unzipping all plugins
COPY plugins/ /plugins/
RUN set -eux; \
    cd /plugins; \
    for zip in *.zip; do \
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

# Removing old favicon
RUN cd /var/www/html/theme/maker/pix/ && rm favicon.ico

# Adding customizations to plugins
COPY customizations/themes/maker/fonts /var/www/html/theme/maker/fonts
COPY customizations/themes/maker/maker-header.mustache /var/www/html/theme/maker/templates/header.mustache
COPY customizations/themes/maker/icons/mod/ /var/www/html/theme/maker/pix_plugins/mod
COPY customizations/themes/maker/icons/core/f/ /var/www/html/pix/f/
COPY customizations/themes/boost/boost-language_menu.mustache /var/www/html/theme/boost/templates/language_menu.mustache
COPY customizations/certificate/certificate.php /var/www/html/mod/certificate/type/letter_non_embedded/
COPY customizations/themes/maker/favicon.ico /var/www/html/theme/maker/pix/
COPY customizations/mergeuser/config.local.php /var/www/html/admin/tool/mergeusers/config/

RUN chown -R www-data /var/www/html

# Installing odbc for shib sp
COPY mariadb-connector /usr/
RUN apt-get update && \
    apt-get -y install unixodbc odbcinst libapache2-mod-shib gettext && \
    cd /usr && \
    echo "[MariaDB]" > MariaDB_odbc_driver_template.ini && \
    echo "Description = MariaDB Connector/ODBC v.3.1" >> MariaDB_odbc_driver_template.ini && \
    echo "Driver = /usr/lib/libmaodbc.so" >> MariaDB_odbc_driver_template.ini && \
    odbcinst -i -d -f MariaDB_odbc_driver_template.ini

COPY shibboleth2.xml-template /etc/shibboleth/
COPY moodle-shib.conf /etc/apache2/conf-enabled/
COPY docker-entrypoint.d/* /docker-entrypoint.d/
COPY 000-default.conf /etc/apache2/sites-available/

# Update language menu
RUN sed -i.bak '/public function lang_menu/ i\ public function get_language() {return current_language();}\n' /var/www/html/lib/outputrenderers.php

# Supress "your site not registered" message
RUN sed -i 's|echo $adminrenderer->warn_if_not_registered();|//echo $adminrenderer->warn_if_not_registered();|g' /var/www/html/admin/search.php 

RUN sleep 3 && echo "\$THEME->removedprimarynavitems = ['courses'];" >> /var/www/html/theme/maker/config.php

RUN chmod -R 755 /docker-entrypoint.d/
