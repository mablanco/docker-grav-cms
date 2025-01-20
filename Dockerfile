FROM php:8.3.13-apache
ARG DEBIAN_FRONTEND=noninteractive
ARG GRAV_VERSION=1.7.48
WORKDIR /var/www/html
RUN apt-get update && \
    apt-get -y install libgd-dev libyaml-dev unzip zip libzip-dev && \
    apt-get -yq autoremove && \
    apt-get clean && \
    rm -rf /var/lib/{apt,dpkg,cache,log}
RUN curl -s -LO https://github.com/getgrav/grav/releases/download/$GRAV_VERSION/grav-admin-v$GRAV_VERSION.zip && \
    unzip grav-admin-v$GRAV_VERSION.zip && \
    mv grav-admin/* . && \
    mv grav-admin/.[a-z]* . && \
    rm -rf grav-admin-v$GRAV_VERSION.zip grav-admin && \
    mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini && \
    docker-php-ext-configure zip && \
    docker-php-ext-install -j$(nproc) gd opcache zip && \
    pecl install yaml && \
    docker-php-ext-enable yaml && \
    a2enmod rewrite && \
    chown -R www-data.www-data .
EXPOSE 80
