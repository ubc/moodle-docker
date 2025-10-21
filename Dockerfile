FROM lthub/moodle:4.5.7
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
            auth) dest="/var/www/html/auth";; \
            availability) dest="/var/www/html/availability/condition";; \
            block) dest="/var/www/html/blocks";; \
            enrol) dest="/var/www/html/enrol";; \
            filter) dest="/var/www/html/filter";; \
            format) dest="/var/www/html/course/format";; \
            local) dest="/var/www/html/local";; \
            mod) dest="/var/www/html/mod";; \
            report) dest="/var/www/html/report";; \
            theme) dest="/var/www/html/theme";; \
            tool) dest="/var/www/html/admin/tool";; \
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

# Update language menu
RUN sed -i.bak '/public function lang_menu/ i\ public function get_language() {return current_language();}\n' /var/www/html/lib/outputrenderers.php

# Supress "your site not registered" message
RUN sed -i 's|echo $adminrenderer->warn_if_not_registered();|//echo $adminrenderer->warn_if_not_registered();|g' /var/www/html/admin/search.php 

RUN sleep 3 && echo "\$THEME->removedprimarynavitems = ['courses'];" >> /var/www/html/theme/maker/config.php

RUN chmod -R 755 /docker-entrypoint.d/
