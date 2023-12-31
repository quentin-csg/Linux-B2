FROM php:7.2-apache

WORKDIR /rendu-tp-linux-b2/tp2/php

COPY /src /var/www/html/

COPY /sql /var/www/html/

RUN docker-php-ext-install mysqli
