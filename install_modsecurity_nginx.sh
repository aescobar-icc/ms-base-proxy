#!/bin/bash
git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git

wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz
tar zxvf nginx-$NGINX_VERSION.tar.gz

cd nginx-$NGINX_VERSION
./configure --with-compat --add-dynamic-module=../ModSecurity-nginx
make modules
cp objs/ngx_http_modsecurity_module.so /etc/nginx/modules
cd ..


#Configure, Enable, and Test ModSecurity
mkdir /etc/nginx/modsec
wget -P /etc/nginx/modsec/ https://raw.githubusercontent.com/SpiderLabs/ModSecurity/v3/master/modsecurity.conf-recommended
mv /etc/nginx/modsec/modsecurity.conf-recommended /etc/nginx/modsec/modsecurity.conf
cp ModSecurity/unicode.mapping /etc/nginx/modsec
sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/nginx/modsec/modsecurity.conf


#Setting Up OWASP-CRS
wget https://github.com/SpiderLabs/owasp-modsecurity-crs/archive/v$OWASP_CRS_VERSION.tar.gz
tar -xzvf v$OWASP_CRS_VERSION.tar.gz
mv owasp-modsecurity-crs-$OWASP_CRS_VERSION /usr/local
cd /usr/local/owasp-modsecurity-crs-$OWASP_CRS_VERSION
cp crs-setup.conf.example crs-setup.conf
