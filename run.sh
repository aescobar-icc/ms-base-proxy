#!/bin/ash

#envsubst < /nginx.conf.temp '${INT_PAY_PRE_FINAL} ${INT_PAY_PRE_RETURN}' > /etc/nginx/nginx.conf
cat /nginx.conf.temp > /etc/nginx/nginx.conf

echo "------------ RESULT ------------"

cat /etc/nginx/nginx.conf

exec nginx -g 'daemon off;'