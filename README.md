# docker-grav-cms

Docker image for Grav CMS, a modern open source flat-file CMS (<https://getgrav.org/>).

This image sets up a **development** environment (including the Grav Admin plugin) and relies on Debian Linux, Apache 2 and PHP 8.4 (with `php.ini-development`, so errors are displayed). It should **NEVER** be used in production.

## How to use this image

This will start a Grav CMS instance listening on port 80:

```bash
~ docker run -d -p 80:80 --name grav mablanco/grav-cms
```

If you'd like persistance, you can create a volume for that purpose:

```bash
~ docker volume create grav_web
~ docker run -d -p 80:80 --name grav -v grav_web:/var/www/html mablanco/grav-cms
```

On the first visit Grav redirects to `/admin`, where you create the administrator account.

## Upgrading from Grav 1.7

Image tags up to `1.7.49.5` ship Grav 1.7. Newer tags ship Grav 2, which needs a manual migration: the default theme is now Quark 2 and the admin panel is Admin 2. A persistent volume keeps the files of the Grav version it was created with, so switching image tags does not migrate an existing site. Back up the volume first, then follow the [Grav 2 migration guide](https://getgrav.org/migrate-to-2).

Within Grav 2, update from the admin panel or with `bin/gpm selfupgrade`.

## Building the image

```bash
~ docker build -t mablanco/grav-cms .
```

The Grav version is set with the `GRAV_VERSION` build argument, and the downloaded `grav-admin` release is checked against `GRAV_SHA256`. Update both together. The PECL YAML extension version is set with `PECL_YAML_VERSION`.
