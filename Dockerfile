FROM amd64/php:8.1-cli-bullseye

LABEL maintainer  "Jens Dutzi <jens.dutzi@tf-network.de>"

# define working-directory.
ENV WORKDIR /home/workspace
WORKDIR ${WORKDIR}
VOLUME ${WORKDIR}

#
# installing needed extra-libs etc.
#

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 -y \
        apt-transport-https \
        lsb-release \
        gnupg \
		libfreetype6-dev \
        libjpeg62-turbo-dev \
        libwebp-dev \
        libpng-dev \
        libmcrypt-dev \
        libpng-dev \
        libssl-dev \
        libcurl4-openssl-dev \
        libicu-dev \
        libc-client-dev \
        libkrb5-dev \
        libxml2-dev \
        ssh \
        curl \
        git \
        wget \
        unzip \
        libbz2-dev \
        libzip-dev

#
# Installation of NodeJS
#

# adding NodeJS-Repository and install NodeJS
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo 'deb https://deb.nodesource.com/node_18.x bullseye main' > /etc/apt/sources.list.d/nodesource.list
RUN echo 'deb-src https://deb.nodesource.com/node_18.x bullseye main' >> /etc/apt/sources.list.d/nodesource.list

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -o APT::Install-Suggests=0 -o APT::Install-Recommends=0 -y nodejs

#
# Configuration of PHP and adding some PHP Modules and Xdebug
#

# PHP Install xdebug (pecl bei diversen Architekturen defekt)
RUN pecl install xdebug && \
        docker-php-ext-enable xdebug

RUN set -eux; \
    docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
	&& PHP_OPENSSL=yes docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
	&& docker-php-ext-install \
        pdo_mysql \
        mysqli \
        exif \
        bz2 \
        opcache \
        calendar \
        shmop \
        zip

# Memory Limit und Timezone PHP Setting
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "date.timezone=Europe/Berlin" > $PHP_INI_DIR/conf.d/date_timezone.ini

#
# Installation: composer
#

# Environmental Variables
ENV COMPOSER_HOME /root/composer
ENV PATH "/root/composer/vendor/bin:${PATH}"

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer selfupdate

# Run composer -components and phpunit installation.
RUN composer global require "phpunit/phpunit=*" "squizlabs/php_codesniffer=*" "phpmd/phpmd=*" "sebastian/phpcpd=*" \
                            "wapmorgan/php-deprecation-detector=*"  "friendsofphp/php-cs-fixer=*" \
                            --prefer-source --no-interaction --update-no-dev --no-ansi

#
# Installation: gulp
#

# Allow unsafe-permissions for NPM (needed for arm-images)
#RUN npm config set unsafe-perm true

# Run installation of gulp
RUN npm install --unsafe-perm=true -g gulp

# Image cleanup
RUN apt-get -yqq autoremove && \
    apt-get -yqq clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/* /tmp/* /var/tmp/*

# Image cleanup
RUN apt-get -yqq autoremove && \
    apt-get -yqq clean && \
    rm -rf /var/lib/apt/lists/* /var/cache/* /tmp/* /var/tmp/*

#
# Clean Up Image
#

RUN composer clearcache
RUN apt-get clean && rm -r /var/lib/apt/lists/*