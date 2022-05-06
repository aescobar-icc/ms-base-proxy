#!/bin/ash

# resolve env vars with the given prefix then replace them in the given source file to gernerate the target file
resolve_conf(){
	env_prefix=$1
	source_file=$2
	target_file=$3
	envs=( $(compgen -A variable | grep -i $env_prefix) )

	envs_template=""
	for env in ${envs[@]}; do
		envs_template+=" \${$env}"
	done

	envsubst < $source_file "$envs_template" > $target_file
}

# resolve all .temp files in the given path and apply the env variables to create the final .conf files
# foreach file with the extension .temp, find all env vars that start with the same file name (without the 
# .temp extension and in uppercase) to generate the respective config file
# for example: 
#    if file name is "site_a.temp" then get all env vars that match with "^SITE_A_*" and apply them to the file

resolve_conf_files(){
	TEMP_PATH=$1
	for temp in $(ls $TEMP_PATH/*.temp); do
		pre=$(basename $temp .temp)
		res="$pre.conf"
		resolve_conf "^${pre^^}_" $temp $TEMP_PATH/$res
	done
}


#resolve all config files in $SITES_ENABLE_PATH with env values like site_xxx.temp and generate site_xxx.conf with resolved values
resolve_conf_files $NGINX_CONF_SITES_ENABLE_PATH

if [ -f $NGINX_CONF_TEMP_FILE ]; then
	resolve_conf "^NGINX_CONF*" $NGINX_CONF_TEMP_FILE /etc/nginx/nginx.conf
fi


exec nginx -g 'daemon off;'