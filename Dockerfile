FROM lthub/moodle:3.6.3
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>

RUN curl -L https://moodle.org/plugins/download.php/19061/mod_attendance_moodle36_2019022500.zip -o /attendance.zip \
    && cp /attendance.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip attendance.zip \
    && rm attendance.zip \

# Incompatible with Moodle 3.6
#     && curl -L https://moodle.org/plugins/download.php/18669/mod_collaborate_moodle35_2018080800.zip -o /collaborate.zip \
#     && cp /collaborate.zip /var/www/html/mod/ \
#     && cd /var/www/html/mod \
#     && unzip collaborate.zip \
#     && rm collaborate.zip

    && curl -L https://moodle.org/plugins/download.php/19206/mod_questionnaire_moodle36_2018050109.zip -o /questionnaire.zip \
    && cp /questionnaire.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip questionnaire.zip \
    && rm questionnaire.zip \

    && curl -L https://moodle.org/plugins/download.php/14021/block_accessibility_moodle31_2017051700.zip -o /accessibility.zip \
    && cp /accessibility.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip accessibility.zip \
    && rm accessibility.zip \

    && curl -L https://moodle.org/plugins/download.php/19296/qtype_multichoiceset_moodle36_2019040501.zip -o /multichoiceset.zip \
    && cp /multichoiceset.zip /var/www/html/question/type/ \
    && cd /var/www/html/question/type \
    && unzip multichoiceset.zip \
    && rm multichoiceset.zip \

    && curl -L https://moodle.org/plugins/download.php/18171/enrol_autoenrol_moodle36_2018101902.zip -o /autoenrol.zip \
    && cp /autoenrol.zip /var/www/html/enrol/ \
    && cd /var/www/html/enrol \
    && unzip autoenrol.zip \
    && rm autoenrol.zip \

    && curl -L https://moodle.org/plugins/download.php/17251/format_buttons_moodle35_2018062700.zip -o /buttons.zip \
    && cp /buttons.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip buttons.zip \
    && rm buttons.zip

RUN chown -R www-data /var/www/html
