FROM nginx:1.21.3

RUN apt update && \
	apt install certbot -y python-certbot-nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY run.sh /run.sh

CMD /bin/bash exec nginx -g 'daemon off;'