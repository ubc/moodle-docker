FROM lthub/moodle:4.1.19
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>

# https://moodle.org/plugins/mod_questionnaire
RUN curl -L https://moodle.org/plugins/download.php/33023/mod_questionnaire_moodle44_2022121601.zip -o /questionnaire.zip \
    && cp /questionnaire.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip questionnaire.zip \
    && rm questionnaire.zip \

# https://moodle.org/plugins/block_xp
    && curl -L https://moodle.org/plugins/download.php/36948/block_xp_moodle50_2025041303.zip -o /xp.zip \
    && cp /xp.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip xp.zip \
    && rm xp.zip \

# https://moodle.org/plugins/format_socialwall
    && curl -L https://moodle.org/plugins/download.php/16327/format_socialwall_moodle33_2018030700.zip -o /socialwall.zip \
    && cp /socialwall.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip socialwall.zip \
    && rm socialwall.zip \

# https://moodle.org/plugins/format_topcoll
    && curl -L https://moodle.org/plugins/download.php/36758/format_topcoll_moodle45_2024092206.zip -o /topcoll.zip \
    && cp /topcoll.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip topcoll.zip \
    && rm topcoll.zip \

# https://moodle.org/plugins/mod_attendance
    && curl -L https://moodle.org/plugins/download.php/35587/mod_attendance_moodle45_2024072401.zip -o /attendance.zip \
    && cp /attendance.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip attendance.zip \
    && rm attendance.zip \

# https://moodle.org/plugins/block_accessibility
    && curl -L https://moodle.org/plugins/download.php/25162/block_accessibility_moodle311_2021092202.zip -o /accessibility.zip \
    && cp /accessibility.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip accessibility.zip \
    && rm accessibility.zip \

# https://moodle.org/plugins/qtype_multichoiceset
    && curl -L https://moodle.org/plugins/download.php/27343/qtype_multichoiceset_moodle40_2022081100.zip -o /multichoiceset.zip \
    && cp /multichoiceset.zip /var/www/html/question/type/ \
    && cd /var/www/html/question/type \
    && unzip multichoiceset.zip \
    && rm multichoiceset.zip \

# https://moodle.org/plugins/enrol_autoenrol
    && curl -L https://moodle.org/plugins/download.php/35282/enrol_autoenrol_moodle45_2025031400.zip -o /autoenrol.zip \
    && cp /autoenrol.zip /var/www/html/enrol/ \
    && cd /var/www/html/enrol \
    && unzip autoenrol.zip \
    && rm autoenrol.zip \

# https://moodle.org/plugins/format_buttons
    && curl -L https://moodle.org/plugins/download.php/37701/format_buttons_moodle50_2025090500.zip -o /buttons.zip \
    && cp /buttons.zip /var/www/html/course/format/ \
    && cd /var/www/html/course/format \
    && unzip buttons.zip \
    && rm buttons.zip \

# https://moodle.org/plugins/theme_fordson
    && curl -L https://moodle.org/plugins/download.php/24737/theme_fordson_moodle311_2021072100.zip -o /fordson.zip \
    && cp /fordson.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip fordson.zip \
    && rm fordson.zip \

# https://moodle.org/plugins/theme_moove
    && curl -L https://moodle.org/plugins/download.php/34331/theme_moove_moodle45_2024100801.zip -o /moove.zip \
    && cp /moove.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip moove.zip \
    && rm moove.zip \

# https://moodle.org/plugins/theme_waxed
    && curl -L https://moodle.org/plugins/download.php/19691/theme_waxed_moodle38_2019052600.zip -o /waxed.zip \
    && cp /waxed.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip waxed.zip \
    && rm waxed.zip \

# https://moodle.org/plugins/mod_choicegroup
    && curl -L https://moodle.org/plugins/download.php/33936/mod_choicegroup_moodle50_2024111301.zip -o /choicegroup.zip \
    && cp /choicegroup.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip choicegroup.zip \
    && rm choicegroup.zip \

# https://moodle.org/plugins/mod_facetoface
    && curl -L https://moodle.org/plugins/download.php/36987/mod_facetoface_moodle45_2025072400.zip -o /facetoface.zip \
    && cp /facetoface.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip facetoface.zip \
    && rm facetoface.zip \

# https://moodle.org/plugins/mod_scheduler
    && curl -L https://moodle.org/plugins/download.php/29293/mod_scheduler_moodle42_2023052300.zip -o /scheduler.zip \
    && cp /scheduler.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip scheduler.zip \
    && rm scheduler.zip \

# https://moodle.org/plugins/block_configurable_reports
    && curl -L https://moodle.org/plugins/download.php/33800/block_configurable_reports_moodle45_2024051300.zip -o /configurable.zip \
    && cp /configurable.zip /var/www/html/blocks/ \
    && cd /var/www/html/blocks \
    && unzip configurable.zip \
    && rm configurable.zip \
	
# https://moodle.org/plugins/mod_hvp
    && curl -L https://moodle.org/plugins/download.php/34151/mod_hvp_moodle45_2024120900.zip -o /hvp.zip \
    && cp /hvp.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip hvp.zip \
    && rm hvp.zip

RUN chown -R www-data /var/www/html
