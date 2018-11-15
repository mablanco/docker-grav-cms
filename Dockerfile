FROM php:7.2-apache
ARG GRAV_VERSION=1.5.5
WORKDIR /var/www/html
RUN apt-get update && \
    apt-get -y install libgd-dev libyaml-dev unzip && \
    apt-get clean
RUN curl -LO https://github.com/getgrav/grav/releases/download/$GRAV_VERSION/grav-admin-v$GRAV_VERSION.zip && \
    unzip grav-admin-v$GRAV_VERSION.zip && \
    mv grav-admin/* . && \
    mv grav-admin/.[a-z]* . && \
    rm -rf grav-admin-v$GRAV_VERSION.zip grav-admin
RUN mv $PHP_INI_DIR/php.ini-development $PHP_INI_DIR/php.ini
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install -j$(nproc) zip
RUN docker-php-ext-install -j$(nproc) opcache
RUN pecl install yaml && \
    docker-php-ext-enable yaml
RUN apt-get -y --purge remove libgd-dev libyaml-dev
RUN a2enmod rewrite
RUN chown -R www-data.www-data .
EXPOSE 80
