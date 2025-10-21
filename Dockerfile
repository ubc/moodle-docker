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

RUN chown -R www-data /var/www/html
