FROM lthub/moodle:3.6.4.1
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>

RUN curl -L https://moodle.org/plugins/download.php/18626/mod_customcert_moodle36_2018120301.zip -o /customcert.zip \
    && cp /customcert.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip customcert.zip \
    && rm customcert.zip \

    && curl -L https://moodle.org/plugins/download.php/11565/mod_certificate_moodle33_2016052300.zip -o /certificate.zip \
    && cp /certificate.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip certificate.zip \
    && rm certificate.zip \

    && curl -L https://moodle.org/plugins/download.php/17344/mod_choicegroup_moodle35_2018070900.zip -o /choicegroup.zip \
    && cp /choicegroup.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip choicegroup.zip \
    && rm choicegroup.zip \

    && curl -L https://moodle.org/plugins/download.php/18183/mod_facetoface_moodle35_2018110900.zip -o /facetoface.zip \
    && cp /facetoface.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip facetoface.zip \
    && rm facetoface.zip \

    && curl -L https://moodle.org/plugins/download.php/18351/mod_scheduler_moodle36_2018112600.zip -o /scheduler.zip \
    && cp /scheduler.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip scheduler.zip \
    && rm scheduler.zip \

    && curl -L https://moodle.org/plugins/download.php/18988/block_configurable_reports_moodle36_2019021500.zip -o /configurable.zip \
    && cp /configurable.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip configurable.zip \
    && rm configurable.zip \

    && curl -L https://moodle.org/plugins/download.php/17067/block_quickmail_moodle35_2017122001.zip -o /quickmail.zip \
    && cp /quickmail.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip quickmail.zip \
    && rm quickmail.zip \

    && curl -L https://moodle.org/plugins/download.php/19118/qtype_ordering_moodle36_2019030689.zip -o /ordering.zip \
    && cp /ordering.zip /var/www/html/question/type/ \
    && cd /var/www/html/question/type \
    && unzip ordering.zip \
    && rm ordering.zip \

    && curl -L https://moodle.org/plugins/download.php/18171/enrol_autoenrol_moodle36_2018101902.zip -o /autoenrol.zip \
    && cp /autoenrol.zip /var/www/html/enrol/ \
    && cd /var/www/html/enrol \
    && unzip autoenrol.zip \
    && rm autoenrol.zip \

    && curl -L https://moodle.org/plugins/download.php/16883/tool_mergeusers_moodle35_2018050401.zip -o /mergeusers.zip \
    && cp /mergeusers.zip /var/www/html/admin/tool/ \
    && cd /var/www/html/admin/tool \
    && unzip mergeusers.zip \
    && rm mergeusers.zip \

    && curl -L https://moodle.org/plugins/download.php/12570/theme_base_moodle33_2016052300.zip -o /base.zip \
    && cp /base.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip base.zip \
    && rm base.zip \

    && curl -L https://moodle.org/plugins/download.php/12571/theme_canvas_moodle32_2016052300.zip -o /canvas.zip \
    && cp /canvas.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip canvas.zip \
    && rm canvas.zip \

    && curl -L https://github.com/ubc/ubc-blue/archive/master.zip -o /ubcblue.zip \
    && cp /ubcblue.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip ubcblue.zip \
    && rm ubcblue.zip \
    && mv ubc-blue-master ubc_blue \

    && docker-php-ext-install exif \

    && chown -R www-data /var/www/html

# install odbc for shib sp
RUN echo "deb http://ftp.debian.org/debian stretch-backports main" | sudo tee /etc/apt/sources.list.d/backports.list && \
    apt-get update && \
    apt-get -y -t stretch-backports install unixodbc libapache2-mod-shib gettext && \
    cd /usr && \
    curl https://downloads.mariadb.com/Connectors/odbc/connector-odbc-3.1.1/mariadb-connector-odbc-3.1.1-ga-debian-x86_64.tar.gz | tar -xvz && \
    echo "[MariaDB]" > MariaDB_odbc_driver_template.ini && \
    echo "Description = MariaDB Connector/ODBC v.3.1" >> MariaDB_odbc_driver_template.ini && \
    echo "Driver = /usr/lib/libmaodbc.so" >> MariaDB_odbc_driver_template.ini && \
    odbcinst -i -d -f MariaDB_odbc_driver_template.ini

# add logic for payment
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends git \
    && cd /tmp \
    && git clone https://gitlab+deploy-token-8:2VsJCQzRsyy9pGfeSiCa@repo.code.ubc.ca/lt/rms-moodle-payments.git \
    && cp -rp rms-moodle-payments/ubc_course_payments /var/www/html \
    && cp -rp rms-moodle-payments/moodle/grade/course_payment /var/www/html/grade \
    && cp rms-moodle-payments/moodle-payments-shib.conf /etc/apache2/conf-enabled/ \
    && cd /tmp && rm -fR rms-moodle-payments

COPY shibboleth2.xml-template /etc/shibboleth/
COPY moodle-shib.conf /etc/apache2/conf-enabled/
COPY docker-entrypoint.d/* /docker-entrypoint.d/
COPY 000-default.conf /etc/apache2/sites-available/
