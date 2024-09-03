FROM lthub/moodle:4.1.13-php8.1
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>

RUN curl -L https://moodle.org/plugins/download.php/33023/mod_questionnaire_moodle44_2022121601.zip -o /questionnaire.zip \
    && cp /questionnaire.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip questionnaire.zip \
    && rm questionnaire.zip \

    && curl -L https://moodle.org/plugins/download.php/31773/block_xp_moodle44_2024042104.zip -o /xp.zip \
    && cp /xp.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip xp.zip \
    && rm xp.zip \

    && curl -L https://moodle.org/plugins/download.php/16327/format_socialwall_moodle33_2018030700.zip -o /socialwall.zip \
    && cp /socialwall.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip socialwall.zip \
    && rm socialwall.zip \

    && curl -L https://moodle.org/plugins/download.php/29775/format_topcoll_moodle41_2022112602.zip -o /topcoll.zip \
    && cp /topcoll.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip topcoll.zip \
    && rm topcoll.zip \

    && curl -L https://moodle.org/plugins/download.php/32671/mod_attendance_moodle41_2023020108.zip -o /attendance.zip \
    && cp /attendance.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip attendance.zip \
    && rm attendance.zip \

    && curl -L https://moodle.org/plugins/download.php/25162/block_accessibility_moodle311_2021092202.zip -o /accessibility.zip \
    && cp /accessibility.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip accessibility.zip \
    && rm accessibility.zip \

    && curl -L https://moodle.org/plugins/download.php/27343/qtype_multichoiceset_moodle40_2022081100.zip -o /multichoiceset.zip \
    && cp /multichoiceset.zip /var/www/html/question/type/ \
    && cd /var/www/html/question/type \
    && unzip multichoiceset.zip \
    && rm multichoiceset.zip \

    && curl -L https://moodle.org/plugins/download.php/31161/enrol_autoenrol_moodle43_2024021900.zip -o /autoenrol.zip \
    && cp /autoenrol.zip /var/www/html/enrol/ \
    && cd /var/www/html/enrol \
    && unzip autoenrol.zip \
    && rm autoenrol.zip \

    && curl -L https://moodle.org/plugins/download.php/28551/format_buttons_moodle41_2022020801.zip -o /buttons.zip \
    && cp /buttons.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip buttons.zip \
    && rm buttons.zip \

    && curl -L https://moodle.org/plugins/download.php/24737/theme_fordson_moodle311_2021072100.zip -o /fordson.zip \
    && cp /fordson.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip fordson.zip \
    && rm fordson.zip \

    && curl -L https://moodle.org/plugins/download.php/28087/theme_moove_moodle41_2022112801.zip -o /moove.zip \
    && cp /moove.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip moove.zip \
    && rm moove.zip \

    && curl -L https://moodle.org/plugins/download.php/19691/theme_waxed_moodle38_2019052600.zip -o /waxed.zip \
    && cp /waxed.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip waxed.zip \
    && rm waxed.zip \

    && curl -L https://moodle.org/plugins/download.php/30464/mod_choicegroup_moodle43_2023110900.zip -o /choicegroup.zip \
    && cp /choicegroup.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip choicegroup.zip \
    && rm choicegroup.zip \

    && curl -L https://moodle.org/plugins/download.php/30030/mod_facetoface_moodle41_2023031300.zip -o /facetoface.zip \
    && cp /facetoface.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip facetoface.zip \
    && rm facetoface.zip \

    && curl -L https://moodle.org/plugins/download.php/29293/mod_scheduler_moodle42_2023052300.zip -o /scheduler.zip \
    && cp /scheduler.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip scheduler.zip \
    && rm scheduler.zip \

    && curl -L https://moodle.org/plugins/download.php/31973/block_configurable_reports_moodle42_2023121803.zip -o /configurable.zip \
    && cp /configurable.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip configurable.zip \
    && rm configurable.zip

RUN chown -R www-data /var/www/html
