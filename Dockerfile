FROM lthub/moodle:3.6.4
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

    && chown -R www-data /var/www/html
