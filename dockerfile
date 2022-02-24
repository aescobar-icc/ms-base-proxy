FROM nginx:1.21.3

RUN apt-get update && \
	apt-get install certbot -y python-certbot-nginx

RUN mkdir -p /data/nginx/cache

COPY nginx.conf /etc/nginx/nginx.conf
COPY run.sh /run.sh


CMD exec nginx -g 'daemon off;'