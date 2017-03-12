#!/bin/bash

## MapServer web mapping as a service (fastcgi) behind ngnix

# update, install and clean :
apt-get -qy update
apt-get -qy --no-install-recommends --no-install-suggests install \
    ssl-cert \
    geoip-database \
    xml-core \
    nginx-full \
    gettext-base
apt-get -qy clean
rm -r /var/lib/apt/lists/*

mkdir -p /etc/nginx/ssl
mkdir -p /etc/nginx/sites-enabled
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# forward request and error logs to docker log collector
chown -R www-data:www-data /geodata
ln -sf /dev/stdout /var/log/nginx/access.log
ln -sf /dev/stderr /var/log/nginx/error.log

# set up self-signed SSL certificate for a year
/tmp/generate_sslcert.sh
mv localhost.key /etc/nginx/ssl/
mv localhost.crt /etc/nginx/ssl/
rm -f localhost.csr /tmp/generate_sslcert.sh

exit 0

