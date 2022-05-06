FROM nginx:1.21.3

ENV NGINX_CONF_MAX_BODY_SIZE="100M"
ENV NGINX_CONF_SITES_ENABLE_PATH="/etc/nginx/sites-enabled"
ENV NGINX_CONF_TEMP_FILE="/etc/nginx/nginx.temp"

RUN apt-get update && \
	apt-get install certbot -y python-certbot-nginx

RUN mkdir -p /data/nginx/cache

COPY nginx.temp /etc/nginx/nginx.temp
COPY run.sh /run.sh


#CMD exec nginx -g 'daemon off;'
ENTRYPOINT bash /run.sh