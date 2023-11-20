## MoodleCPD 4.1LTS 
* Documentation in progress....

<img width="847" alt="MoodleCPD_L2" src="https://github.com/ubc/moodle-docker/assets/86985864/bb61e8a3-866d-4f5e-8a62-1a900e874511">


## Build MoodleCPD Image

* Step 1-2: build MoodleCore 4.1-LTS
  - Source to build MoodleCore https://github.com/ubc/moodle-docker/tree/moodlecore-4.1LTS 


* Step 3: for development 

* HOW-TO Build MoodleCPD from MoodleCore 4.1-LTS with Github > Codespace
* - (optional) fork "moodlecpd-4.1LTS" branch
  - From "moodlecpd-4.1LTS" branch:
  - click on the (green button) "<> CODE"
  - select "Codespaces" tab
  - click the + to launch Codespaces instance
    - This will launch a default Codespaces instance with 2-core 8GB RAM, 32GB (sufficient to build this image)
    - The browser navigates to the codespace instance: something like this... [some random name]gp.github.dev
    - At bottom, select tab "Terminal" - this is bash shell
    - Edit Dockerfile or other
    - After completed the change (if any), then do build image

  - Execute > docker-compose build
    - After build completed, tag the image. 

  - (optional) docker login -u [your hub.docker.com accout]

  - Execute > docker tag [some image ID] [your hub.docker.com accout]/moodlecpd:4.1.6-[some unique id] 
    - example, docker tag eb73e7a5c010 hubdocker2020/moodlecpd:4.1.6-eb73e7a5c010

  - Execute > docker push [your hub.docker.com accout]/moodlecpd:4.1.6-[some unique id]
    - example, docker push hubdocker2020/moodlecpd:4.1.6-eb73e7a5c010

  - DONE with buidling MoodleCPD 4.1 LTS, this image to your hub.docker.com account. 



* Step 4: for deployment to STAGING or PROD

* After completion of Step 3 above:

  - commit the change back to main repo branch "moodlecpd-4.1LTS" from the Github > Codespaces instance above. 

  - this "commit" step will initiate the automatic building of the image to LTHub, making it ready for the next step 5: HELM launch.

  - DONE with MoodleCPD 4.1 LTS, the Moodle Core image is on LTHub: https://hub.docker.com/u/lthub



* Step 5: for building MoodleCPD with MoodleCore image from Step 3 OR Step 4 above:

  - Launch HELM: 

    - helm INSTALL -n default -f ./configuration/moodle/values_stg2.yaml  moodle-medicine-stg2 ./charts/moodle/

  - OR 

    - helm UPGRADE -n default -f ./configuration/moodle/values_stg2.yaml  moodle-medicine-stg2 ./charts/moodle/

-----------------------

* Optional Moodle CLI commands:

  - upgrade command: php ./admin/cli/upgrade.php
  - clear cache command: php ./admin/cli/purge_cache.php

-----------------------

## Known Issues

* When using NFS shared volume for `/moodledata`, you may get `session data file is not created by your uid` error. It is due to the NFS mount user id mapping is not consistent with local user id. Use Redis session for workaround.
* By default application cache is using file store, which is pretty slow. Configure Redis to be used for application cache: `Site administration`->`plugins`->`caching`->`Configuration`->under `Redis` row, click add instance
