FROM nginx:1.21.3

RUN apt-get update && \
	apt-get install certbot -y python-certbot-nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY run.sh /run.sh

CMD exec nginx -g 'daemon off;'