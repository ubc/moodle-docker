FROM lthub/moodle:3.9.11
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>

RUN curl -L https://moodle.org/plugins/download.php/19206/mod_questionnaire_moodle36_2018050109.zip -o /questionnaire.zip \
    && cp /questionnaire.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip questionnaire.zip \
    && rm questionnaire.zip \

    && curl -L https://moodle.org/plugins/download.php/19208/block_xp_moodle36_2019032102.zip -o /xp.zip \
    && cp /xp.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip xp.zip \
    && rm xp.zip \

    && curl -L https://moodle.org/plugins/download.php/16327/format_socialwall_moodle33_2018030700.zip -o /socialwall.zip \
    && cp /socialwall.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip socialwall.zip \
    && rm socialwall.zip \

    && curl -L https://moodle.org/plugins/download.php/19238/format_topcoll_moodle36_2018121901.zip -o /topcoll.zip \
    && cp /topcoll.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip topcoll.zip \
    && rm topcoll.zip \

    && curl -L https://moodle.org/plugins/download.php/19061/mod_attendance_moodle36_2019022500.zip -o /attendance.zip \
    && cp /attendance.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip attendance.zip \
    && rm attendance.zip \

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

    && curl -L https://moodle.org/plugins/download.php/25412/enrol_autoenrol_moodle311_2021101800.zip -o /autoenrol.zip \
    && cp /autoenrol.zip /var/www/html/enrol/ \
    && cd /var/www/html/enrol \
    && unzip autoenrol.zip \
    && rm autoenrol.zip \

    && curl -L https://moodle.org/plugins/download.php/17251/format_buttons_moodle35_2018062700.zip -o /buttons.zip \
    && cp /buttons.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip buttons.zip \
    && rm buttons.zip \

    && curl -L https://moodle.org/plugins/download.php/19255/theme_fordson_moodle36_2019111003.zip -o /fordson.zip \
    && cp /fordson.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip fordson.zip \
    && rm fordson.zip \

    && curl -L https://moodle.org/plugins/download.php/19083/theme_moove_moodle36_2019022800.zip -o /moove.zip \
    && cp /moove.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip moove.zip \
    && rm moove.zip \

    && curl -L https://moodle.org/plugins/download.php/18461/theme_waxed_moodle36_2018120500.zip -o /waxed.zip \
    && cp /waxed.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip waxed.zip \
    && rm waxed.zip \

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
    && rm configurable.zip

RUN chown -R www-data /var/www/html
