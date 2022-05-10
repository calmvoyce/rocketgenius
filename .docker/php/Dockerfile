FROM php:7.4-fpm

RUN apt-get update -y && apt-get install -y libpng-dev zlib1g-dev

RUN docker-php-ext-install mysqli gd

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
RUN export PAGER='busybox less'
RUN cd /usr/local/etc/php/conf.d/
RUN echo 'memory_limit = 600M' >> /usr/local/etc/php/conf.d/docker-php-ram-limit.ini
RUN echo 'max_execution_time = 600' >> /usr/local/etc/php/conf.d/docker-php-time-limit.ini