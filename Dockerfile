FROM php:8.4.27-apache@sha256:be1326658a7d36dba6be79a71212d6ff9c5f854335b8ba77d714da1852c1b2ea
ARG DEBIAN_FRONTEND=noninteractive
ARG GRAV_VERSION=2.2.14
ARG GRAV_SHA256=0852badebca0ec075c1d177cc2336714f1d27aa69a05b21db12b44db7696345c
ARG PECL_YAML_VERSION=2.3.0
WORKDIR /var/www/html
# Build the PHP extensions, then keep only the runtime libraries they link to
RUN set -eux; \
    savedAptMark="$(apt-mark showmanual)"; \
    apt-get update; \
    apt-get -y upgrade; \
    apt-get -y install --no-install-recommends \
        libfreetype-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libwebp-dev \
        libyaml-dev \
        libzip-dev \
        unzip; \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp; \
    docker-php-ext-install -j"$(nproc)" gd opcache zip; \
    pecl install "yaml-${PECL_YAML_VERSION}"; \
    docker-php-ext-enable yaml; \
    rm -rf /tmp/pear; \
    curl -fsSL -o grav.zip \
        "https://github.com/getgrav/grav/releases/download/${GRAV_VERSION}/grav-admin-v${GRAV_VERSION}.zip"; \
    echo "${GRAV_SHA256}  grav.zip" | sha256sum -c -; \
    unzip -q grav.zip -d /tmp; \
    cp -a /tmp/grav-admin/. .; \
    rm -rf grav.zip /tmp/grav-admin; \
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); printf "*%s\n", so }' \
        | sort -u \
        | xargs -r dpkg-query --search \
        | cut -d: -f1 \
        | sort -u \
        | xargs -r apt-mark manual; \
    apt-get -y purge --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*; \
    mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"; \
    a2enmod rewrite; \
    chown -R www-data:www-data .
EXPOSE 80
