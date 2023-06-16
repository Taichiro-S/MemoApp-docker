FROM php:8.1-fpm-bullseye AS base

WORKDIR /workspace

ENV TZ=UTC \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US:en \
  LC_ALL=en_US.UTF-8 \
  COMPOSER_ALLOW_SUPERUSER=1 \
  COMPOSER_HOME=/composer

COPY --from=composer:2.4 /usr/bin/composer /usr/bin/composer

RUN apt-get update \
  && apt-get -y install --no-install-recommends \
    locales \
    git \
    unzip \
    libzip-dev \
    libicu-dev \
    libonig-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen en_US.UTF-8 \
  && localedef -f UTF-8 -i en_US en_US.UTF-8 \
  && docker-php-ext-install \
    intl \
    pdo_mysql \
    zip \
    bcmath \
  && composer config -g process-timeout 3600 \
  && composer config -g repos.packagist composer https://packagist.org

FROM base AS development

COPY ./docker/backend/php.development.ini /usr/local/etc/php/php.ini

RUN pecl install xdebug && \
  docker-php-ext-enable xdebug

COPY ./docker/backend/xdebug.ini /usr/local/etc/php/conf.d/xdebug.ini

FROM base AS production

COPY ./docker/backend/php.production.ini /usr/local/etc/php/php.ini

COPY ./src_backend_laravel-10 /workspace/

RUN chown -R www-data:www-data /workspace

RUN composer install -q -n --no-ansi --no-dev --no-scripts --no-progress --prefer-dist \
  && chmod -R 777 storage bootstrap/cache \
  && php artisan optimize:clear \
  && php artisan optimize

CMD ["php-fpm"]

EXPOSE 9000