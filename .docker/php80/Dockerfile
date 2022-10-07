FROM php:8.0-fpm-alpine

# Install system dependencies
RUN apk update && apk add curl zip unzip git openssh su-exec

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Install PHP extensions
RUN install-php-extensions zip intl mcrypt exif pcntl bcmath gd\
  pdo_mysql pdo_dblib pdo_oci pdo_odbc pdo_pgsql pdo_sqlsrv oci8 odbc pgsql sqlsrv bz2 sockets

# Get latest Composer
COPY --from=composer:2.0 /usr/bin/composer /usr/local/bin/composer

# Set working directory
WORKDIR /webapps/php80

# Create system user to run Composer and Artisan Commands
# RUN adduser -G www-data -u 1000 -g 1000 -h /webapps -S www-data
RUN mkdir -p /webapps/.composer && \
    mkdir -p /webapps/php80 && \
    mkdir -p /.config && \
    chown -R 1000:1000 /webapps && \
    chown -R 1000:1000 /.config

USER 1000

VOLUME /webapps

CMD ["php-fpm", "-R"]
