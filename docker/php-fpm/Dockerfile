FROM php:8.2-fpm


ARG USER_UID
ARG USER_GID
ARG TIMEZONE

# Set timezone
RUN echo ${TIMEZONE} > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libxml2-dev \
    git \
    unzip && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd zip pdo pdo_mysql opcache

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash && \
    mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

# Install xdebug
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug

# Configure Xdebug
RUN echo '[xdebug]' > /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo 'zend_extension=xdebug' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo 'xdebug.mode=debug' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo 'xdebug.start_with_request=trigger' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo 'xdebug.discover_client_host=0' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo 'xdebug.client_host=host.docker.internal' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo 'xdebug.client_port=9003' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo 'xdebug.idekey=PHPSTORM' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo 'xdebug.log=/home/symfony/xdebug.log' >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Comment out user and group directives in www.conf to avoid startup notices
RUN sed -i -e 's/^user = .*/;user = symfony/' -e 's/^group = .*/;group = symfony/' /usr/local/etc/php-fpm.d/www.conf

# Launch PHP-FPM
CMD ["php-fpm"]

ARG UID=1000
ARG GID=1000
# Create new user for permission
RUN groupadd -g ${GID} symfony && \
    useradd -u ${USER_UID} -g ${GID} -m symfony


# Set working directory
WORKDIR /var/www

# Switch back to the non-root user
USER symfony