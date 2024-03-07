FROM lthub/moodle:4.1.9-1
MAINTAINER Tyler Cinkant <tyler.cinkant@ubc.ca>

RUN curl -L https://moodle.org/plugins/download.php/28807/mod_attendance_moodle41_2023020107.zip -o /attendance.zip \
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

    && curl -L https://moodle.org/plugins/download.php/29228/mod_questionnaire_moodle42_2022092202.zip -o /questionnaire.zip \
    && cp /questionnaire.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip questionnaire.zip \
    && rm questionnaire.zip \

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
	
	&& curl -L https://moodle.org/plugins/download.php/29744/theme_learnr_moodle42_2023071008.zip -o /learnr.zip \
    && cp /learnr.zip /var/www/html/theme/ \
    && cd /var/www/html/theme \
    && unzip learnr.zip \
    && rm learnr.zip \

	&& curl -L https://moodle.org/plugins/download.php/29293/mod_scheduler_moodle42_2023052300.zip -o /scheduler.zip \
    && cp /scheduler.zip /var/www/html/mod/ \
    && cd /var/www/html/mod \
    && unzip scheduler.zip \
    && rm scheduler.zip \

	&& curl -L https://moodle.org/plugins/download.php/14412/message_slack_moodle33_2017040403.zip -o /slack.zip \
    && cp /slack.zip /var/www/html/message/output/ \
    && cd /var/www/html/message/output \
    && unzip slack.zip \
    && rm slack.zip

RUN chown -R www-data /var/www/html
