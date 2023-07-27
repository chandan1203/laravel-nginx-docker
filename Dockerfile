FROM php:8-fpm

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions pdo_mysql zip


# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    curl


# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# RUN apt-get update && apt-get install -y \
#     zip \
#     libfreetype6-dev \
#     libjpeg62-turbo-dev \
#     libpng-dev \
#     && docker-php-ext-configure gd --with-freetype --with-jpeg \
#     && docker-php-ext-install -j$(nproc) gd \
#     && docker-php-ext-install pdo_mysql \
#     && docker-php-ext-install bcmath \
#     && docker-php-ext-install swoole

# for php-apache configuation
# COPY ./server-config/000-default.conf /etc/apache2/sites-available/000-default.conf
# RUN a2enmod rewrite &&\
#     service apache2 restart

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
WORKDIR /var/www

# COPY  composer.json ./composer.json

COPY . /var/www

# RUN composer install
# VOLUME /app/vendor

# RUN chmod -R 777 storage/*
# RUN chmod -R 777 bootstrap/cache

# CMD php artisan serve --host=0.0.0.0 --port=8000
# EXPOSE 8000

EXPOSE 9000
CMD ["php-fpm"]
