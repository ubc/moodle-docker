## Moodle 4.1LTS CORE
* Documentation in progress....

<img width="351" alt="moodleCPDDesign1" src="https://github.com/ubc/moodle-docker/assets/86985864/acb614d9-cdb2-470c-a816-4095b96e987a">

## Build Image

* Step 1: for development 

* HOW-TO Build Moodle CPD from MoodleCore 4.1-LTS with Github > Codespace

** - (optional) fork "moodlecore-4.1LTS" branch

** - From "moodlecore-4.1LTS" branch:
    - click on the (green button) "<> CODE" 
    - select "Codespaces" tab 
    - click the + to launch Codespaces instance

** - This will launch a default Codespaces instance with 2-core 8GB RAM, 32GB (sufficient to build this image)

** - The browser navigates to the codespace instance: something like this... <some random name>gp.github.dev

** - At bottom, select tab "Terminal" - this is bash shell 
    - Edit Dockerfile or other 
    - After completed the change (if any), then do build image

** - Execute > docker-compose build
    - After build completed, tag the image. 

** - (optional) docker login -u <your hub.docker.com accout>

** - Execute > docker tag <some image ID> <your hub.docker.com accout>/moodlecore:4.1.6-<unique id>
    - example, docker tag eb73e7a5c010 hubdocker2020/moodlecore:4.1.6-eb73e7a5c010

** - Execute > docker push <your hub.docker.com accout>/moodlecore:4.1.6-<unique id>
    - example, docker push hubdocker2020/moodlecore:4.1.6-eb73e7a5c010

** - DONE with MoodleCore 4.1 LTS, on your hub.docker.com account. 



* Step 2: for deployment to STAGING or PROD

* After completion of Option 1 above:

** - commit the change back to main repo branch "moodlecore-4.1LTS"

** - this action will trigger auto build of image and it should be ready for next step

** - DONE with MoodleCore 4.1 LTS, but on LTHub: https://hub.docker.com/u/lthub



* Step 3: for building Moodle CPD with images from Step 1 or Step 2 above:

** Link here: https://github.com/ubc/moodle-docker/tree/moodlecpd-4.1LTS

-----------------------

* Source: https://moodledev.io/general/releases/4.1

## Known Issues

* When using NFS shared volume for `/moodledata`, you may get `session data file is not created by your uid` error. It is due to the NFS mount user id mapping is not consistent with local user id. Use Redis session for workaround.
* By default application cache is using file store, which is pretty slow. Configure Redis to be used for application cache: `Site administration`->`plugins`->`caching`->`Configuration`->under `Redis` row, click add instance
