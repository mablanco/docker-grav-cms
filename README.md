# docker-grav-cms
Docker image for Grav CMS, a modern open source flat-file CMS (https://getgrav.org/).

This image sets up a development environment (including Grav Admin plugin) and relies on Debian Linux, Apache 2 and PHP7.

## How to use this image

This will start a Grav CMS instance listening on port 80:

```
$ docker run -d -p 80:80 --name grav mablanco/grav-cms
```

If you'd like persistance, you can create a volume for that purpose:

```
$ docker volume create grav_web
$ docker run -d -p 80:80 --name grav -v grav_web:/var/www/html mablanco/grav-cms
```
