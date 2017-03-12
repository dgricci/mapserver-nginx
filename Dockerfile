## MapServer web mapping as a service (fastcgi) behind ngnix
FROM dgricci/mapserver:0.0.4
MAINTAINER Didier Richard <didier.richard@ign.fr>

# copy nginx configuration :
COPY etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY etc/nginx/sites-available/default /etc/nginx/sites-available/default

# set up self-signed SSL certificate for a year
COPY generate_sslcert.sh /tmp/generate_sslcert.sh

RUN /tmp/build.sh && rm -f /tmp/build.sh

# listen to port 80 and 443 of this container
EXPOSE 80 443

# Externally accessible data is by default put in /geodata
# use -v at run time !
WORKDIR /geodata
# to ensure that nginx stays in the foreground so that Docker can track the
# process properly (otherwise your container will stop immediately after
# starting)!

CMD service fcgiwrap start && nginx -g "daemon off;"

