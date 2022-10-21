FROM nginx:1.21.3

ENV NGINX_CONF_MAX_BODY_SIZE="100M"
ENV NGINX_CONF_SITES_ENABLE_PATH="/etc/nginx/sites-enabled"
ENV NGINX_CONF_TCP_PATH="/etc/nginx/tcp-config/"
ENV NGINX_CONF_TEMP_FILE="/etc/nginx/nginx.temp"
ENV OWASP_CRS_VERSION=3.0.2
ENV WEB_USER=www-data

#allow apply env that only starts with the same prefix name of config.temp file
ENV USE_ENV_PREFIX=yes

USER root

RUN apt-get update && \
	apt-get install certbot -y python-certbot-nginx

#REF: https://www.nginx.com/blog/compiling-and-installing-modsecurity-for-open-source-nginx/
RUN mkdir -p /modsecurity_builds
WORKDIR /modsecurity_builds
#ModSecurity: Install Prerequisite Packages
RUN apt-get install -y apt-utils autoconf automake build-essential git libcurl4-openssl-dev libgeoip-dev liblmdb-dev libpcre++-dev libtool libxml2-dev libyajl-dev pkgconf wget zlib1g-dev
#ModSecurity: compile 3.0 Source Code
COPY install_modsecurity.sh /modsecurity_builds/install_modsecurity.sh
RUN bash /modsecurity_builds/install_modsecurity.sh
#ModSecurity: NGINX Connector
COPY install_modsecurity_nginx.sh /modsecurity_builds/install_modsecurity_nginx.sh
RUN bash /modsecurity_builds/install_modsecurity_nginx.sh

COPY nginx.temp /etc/nginx/nginx.temp
COPY main.conf /etc/nginx/modsec/main.conf

RUN mkdir -p /data/nginx/cache
RUN mkdir -p /var/cache/nginx/client_temp
RUN chown -R $WEB_USER  /var/cache/nginx/
RUN chown -R $WEB_USER  /data/nginx/
RUN chown -R $WEB_USER  /etc/nginx
RUN chown -R $WEB_USER  /run/
RUN chown -R $WEB_USER  /usr/local/owasp-modsecurity-crs-$OWASP_CRS_VERSION/

COPY run.sh /run.sh

USER $WEB_USER 
#CMD exec nginx -g 'daemon off;'
ENTRYPOINT bash /run.sh