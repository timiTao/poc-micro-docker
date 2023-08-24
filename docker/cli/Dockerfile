# syntax=docker/dockerfile:1.4

ARG COMPOSER_BASE

FROM php:8.2.5-cli-alpine AS base
USER root
WORKDIR /app

RUN docker-php-ext-install pdo_mysql opcache

FROM base AS development
USER root

RUN apk add --no-cache --update \
    ${PHPIZE_DEPS} \
    linux-headers
RUN pecl install xdebug && docker-php-ext-enable xdebug


FROM $COMPOSER_BASE AS composer
USER root
ENV COMPOSER_ALLOW_SUPERUSER=1
COPY --from=composer/composer:2.5.5 --link /usr/bin/composer /usr/local/bin/composer
RUN apk add --no-cache --update \
    git \
    unzip

FROM composer AS composer-production
USER root

COPY --link ./app/composer.* /app
RUN composer install --no-dev

FROM base AS production-libs

RUN apk update
RUN apk add musl-utils python3 gcc g++ autoconf make
RUN apk add --no-cache ca-certificates

COPY docker/cli/get-deps.py /usr/local/bin
RUN chmod a+x /usr/local/bin/get-deps.py
RUN python3 /usr/local/bin/get-deps.py

FROM scratch AS production
WORKDIR /app
ENV PHP_INI_DIR=/usr/local/etc/php

COPY --from=production-libs --link ${PHP_INI_DIR} ${PHP_INI_DIR}
COPY --from=production-libs --link "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
COPY --from=production-libs --link /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=production-libs --link /tmp/dest /
COPY --from=production-libs --link /usr/local/bin/php /usr/local/bin/php

COPY --from=composer-production --link /app/vendor /app/vendor
COPY /app/public /app/public
COPY /app/src /app/src

CMD ["php"]

