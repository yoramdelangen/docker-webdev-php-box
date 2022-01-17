FROM php:8.0-fpm-alpine

ARG SSL_KEY
ARG SSL_PUB_KEY
ARG LICENSE_FILE

# Install system dependencies
RUN apk update && apk add curl zip unzip git

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# Install PHP extensions
RUN install-php-extensions bcmath zip intl mcrypt mbstring exif pcntl bcmath gd json \
  pdo_mysql pdo_pgsql pdo_dblib pdo_oci pdo_odbc pdo_pgsql pdo_sqlsrv pdo_sqlite oci8 odbc pgsql sqlsrv sqlite3 bz2 zlib;

# Get latest Composer
COPY --from=composer:2.0 /usr/bin/composer /usr/local/bin/composer

# # Create system user to run Composer and Artisan Commands
# RUN useradd -G www-data,root -u $uid -d /home/$user $user
# RUN mkdir -p /home/$user/.composer && \
#     chown -R $user:$user /home/$user

# Set working directory
WORKDIR /webapps

