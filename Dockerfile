FROM php:8.1.13-cli

ENV LANG=fr_FR.UTF-8
ENV LC_ALL=fr_FR.UTF-8
ENV TZ=Europe/Paris

ENV NVM_DIR=/usr/local/nvm
ENV NODE_VERSION=v20.11.1

# Copy php.ini-development in php.ini
# RUN cp usr/local/etc/php/php.ini-development usr/local/etc/php/php.ini

# Intall debian package
RUN apt-get update \
    &&  apt-get install -y --no-install-recommends \
        apt-transport-https \
        apt-utils \
        ca-certificates \
        g++ \
        git \
        gnupg \
        lftp \
        libicu-dev \
        libonig-dev \
        libpng-dev \
        libpq-dev \
        libxml2-dev \
        libxslt-dev \
        libzip-dev \
        locales \
        lsb-release \
        nano \
        software-properties-common \
        tzdata \
        unzip \
        wget \
        zip

# Specify the french locale and timezone
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen  \
    &&  echo "$LANG UTF-8" >> /etc/locale.gen \
    &&  locale-gen \
    &&  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Composer (last version)
RUN curl -sS https://getcomposer.org/installer | php -- \
    &&  mv composer.phar /usr/local/bin/composer

# Install Symfony (last version)
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    &&  mv /root/.symfony5/bin/symfony /usr/local/bin

# Install PHP dependencies
RUN docker-php-ext-configure \
        intl \
    &&  docker-php-ext-install \
        calendar  \
        dom  \
        gd  \
        intl  \
        mbstring  \
        opcache \
        pdo \
        pdo_mysql \
        pdo_pgsql \
        xsl \
        zip

# Install APC User Cache
RUN pecl install apcu && docker-php-ext-enable apcu

# Install apache
RUN apt-get install -y apache2 apache2-utils \
    && a2enmod rewrite \
    && a2enmod headers

# Intall nvm and node
RUN mkdir $NVM_DIR
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/$NODE_VERSION/bin:$PATH

# Install Yarn
RUN npm install --global yarn

# Install OpenJDK 11 JRE
RUN apt-get update \
    && apt-get install -y openjdk-11-jre

# Configure Git
RUN git config --global user.email "you@example.com" \
    &&  git config --global user.name "Your Name"

# Copy files in docker container
COPY etc/ /etc/
COPY var/ /var/

