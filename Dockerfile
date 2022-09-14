FROM lthub/moodle:3.9.17
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>

RUN curl -L https://moodle.org/plugins/download.php/21114/mod_attendance_moodle38_2019112500.zip -o /attendance.zip \
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

    && curl -L https://moodle.org/plugins/download.php/21849/mod_questionnaire_moodle39_2020011508.zip -o /questionnaire.zip \
    && cp /questionnaire.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip questionnaire.zip \
    && rm questionnaire.zip \

    && curl -L https://moodle.org/plugins/download.php/14021/block_accessibility_moodle31_2017051700.zip -o /accessibility.zip \
    && cp /accessibility.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip accessibility.zip \
    && rm accessibility.zip \

    && curl -L https://moodle.org/plugins/download.php/19504/qtype_multichoiceset_moodle38_2019050800.zip -o /multichoiceset.zip \
    && cp /multichoiceset.zip /var/www/html/question/type/ \
    && cd /var/www/html/question/type \
    && unzip multichoiceset.zip \
    && rm multichoiceset.zip \

    && curl -L https://moodle.org/plugins/download.php/26874/enrol_autoenrol_moodle40_2022062000.zip -o /autoenrol.zip \
    && cp /autoenrol.zip /var/www/html/enrol/ \
    && cd /var/www/html/enrol \
    && unzip autoenrol.zip \
    && rm autoenrol.zip \

    && curl -L https://moodle.org/plugins/download.php/20381/format_buttons_moodle38_2019100702.zip -o /buttons.zip \
    && cp /buttons.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip buttons.zip \
    && rm buttons.zip \

    && curl -L https://moodle.org/plugins/download.php/21132/theme_fordson_moodle38_2020030200.zip -o /fordson.zip \
    && cp /fordson.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip fordson.zip \
    && rm fordson.zip \

    && curl -L https://moodle.org/plugins/download.php/20738/mod_scheduler_moodle39_2019120200.zip -o /scheduler.zip \
    && cp /scheduler.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip scheduler.zip \
    && rm scheduler.zip

COPY favicon.ico /var/www/html/theme/boost/pix

RUN chown -R www-data /var/www/html
