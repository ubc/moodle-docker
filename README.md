## MoodleCPD 4.1LTS 
* Documentation in progress....

<img width="351" alt="moodleCPDDesign1" src="https://github.com/ubc/moodle-docker/assets/86985864/acb614d9-cdb2-470c-a816-4095b96e987a">



## Known Issues

* When using NFS shared volume for `/moodledata`, you may get `session data file is not created by your uid` error. It is due to the NFS mount user id mapping is not consistent with local user id. Use Redis session for workaround.
* By default application cache is using file store, which is pretty slow. Configure Redis to be used for application cache: `Site administration`->`plugins`->`caching`->`Configuration`->under `Redis` row, click add instance
