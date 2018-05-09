FROM alpine

# Install dependencies
RUN apk add --no-cache \
    curl \
    nginx \
    php7 \
    php7-bz2 \
    php7-ctype \
    php7-curl \
    php7-fpm \
    php7-gd \
    php7-json \
    php7-mbstring \
    php7-mysqli \
    php7-opcache \
    php7-openssl \
    php7-session \
    php7-xml \
    php7-zip \
    php7-zlib \
    supervisor

# Copy configuration
COPY etc /etc/

# Copy main script
COPY run.sh /run.sh
RUN chmod u+rwx /run.sh

# Calculate download URL
ENV VERSION 4.8.0.1
ENV URL https://files.phpmyadmin.net/phpMyAdmin/${VERSION}/phpMyAdmin-${VERSION}-all-languages.tar.gz
LABEL version=$VERSION

# Download tarball, verify it using gpg and extract
RUN set -ex; \
    apk add --no-cache --virtual .fetch-deps \
        gnupg \
    ; \
    \
    export GNUPGHOME="$(mktemp -d)"; \
    export GPGKEY="3D06A59ECE730EB71B511C17CE752F178259BD92"; \
    curl --output phpMyAdmin.tar.gz --location $URL; \
    curl --output phpMyAdmin.tar.gz.asc --location $URL.asc; \
    gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$GPGKEY" \
        || gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys "$GPGKEY" \
        || gpg --keyserver keys.gnupg.net --recv-keys "$GPGKEY" \
        || gpg --keyserver pgp.mit.edu --recv-keys "$GPGKEY" \
        || gpg --keyserver keyserver.pgp.com --recv-keys "$GPGKEY"; \
    gpg --batch --verify phpMyAdmin.tar.gz.asc phpMyAdmin.tar.gz; \
    rm -rf "$GNUPGHOME"; \
    tar xzf phpMyAdmin.tar.gz; \
    rm -f phpMyAdmin.tar.gz phpMyAdmin.tar.gz.asc; \
    mv phpMyAdmin-$VERSION-all-languages /www; \
    rm -rf /www/setup/ /www/examples/ /www/test/ /www/po/ /www/composer.json /www/RELEASE-DATE-$VERSION; \
    sed -i "s@define('CONFIG_DIR'.*@define('CONFIG_DIR', '/etc/phpmyadmin/');@" /www/libraries/vendor_config.php; \
    chown -R root:nobody /www; \
    find /www -type d -exec chmod 750 {} \; ; \
    find /www -type f -exec chmod 640 {} \; ; \
    apk del .fetch-deps

# Add directory for sessions to allow session persistence
RUN mkdir /sessions \
    && mkdir -p /www/tmp \
    && chmod -R 777 /www/tmp

# We expose phpMyAdmin on port 80
EXPOSE 80

ENTRYPOINT [ "/run.sh" ]
CMD ["phpmyadmin"]
