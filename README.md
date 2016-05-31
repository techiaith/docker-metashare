# Docker META-SHARE Node

This project provides a Docker file and associated files that facilitates easy installation your own instance of a META-SHARE node. 

META-SHARE is an open, integrated, secure and interoperable sharing and exchange facility for LRs (datasets and tools) for the Human Language Technologies domain and other applicative domains where language plays a critical role.

META-SHARE, the open language resource exchange facility, is devoted to the sustainable sharing and dissemination of language resources (LRs) and aims at increasing access to such resources in a global scale.

Example META-SHARE nodes:

http://metashare.techiaith.cymru

http://metashare.elda.org/


## Installation

The steps involved are simple:

`~$ git clone https://github.com/techiaith/docker-metashare.git`

Edit the `local_settings.py` file to contain, in DJANGO_URL, the eventual URL of your META-SHARE website. In our case, it is http://metashare.techiaith.cymru

Enter also under ADMIN in the `local_settings.py` file your admin username and contact e-mail address.

Save changes and simply run:

`~$ make`

This will download all packages, source codes and dependencies to build a Docker image which when run will provide an empty META-SHARE node. 

To run simply type :

`~$ make run`

A META-SHARE node is now running in a Docker container is now running with access possible at port 5030. Your hosting server should have a webserver that recognizes the DJANGO_URL and provides a proxy pass to the Docker port (5030)

e.g. in nginx you would have:

```
server {
    listen 80;
    server_name metashare.myorg.org;
    
    location / {
        proxy_pass http://127.0.0.1:5030;
    }
}
```




