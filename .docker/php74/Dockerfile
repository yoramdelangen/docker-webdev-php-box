FROM php:7.4-fpm-alpine

# Install system dependencies
RUN apk update && apk add curl zip unzip git openssh

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Install PHP extensions
RUN install-php-extensions zip intl mcrypt exif pcntl bcmath gd \
  pdo_mysql pdo_dblib pdo_oci pdo_odbc pdo_pgsql pdo_sqlsrv oci8 odbc pgsql sqlsrv bz2;

# Get latest Composer
COPY --from=composer:2.0 /usr/bin/composer /usr/local/bin/composer

# Create system user to run Composer and Artisan Commands
# RUN adduser -G www-data -u 1000 -g 1000 -h /webapps -S www-data
RUN mkdir -p /webapps/.composer && \
    chown -R www-data:www-data /webapps

USER www-data

# Set working directory
WORKDIR /webapps/php74
