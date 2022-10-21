#!/bin/ash
ls -ltr /etc/nginx/modules/
# resolve env vars with the given prefix then replace them in the given source file to gernerate the target file
resolve_conf(){
	env_prefix=$1
	source_file=$2
	target_file=$3
	
	if [[ "$USE_ENV_PREFIX" == "yes" ]];then
		#filter env vars that match with $env_prefix
		envs=( $(compgen -A variable | grep -i $env_prefix) )
	else
		envs=( $(compgen -A variable ) )
	fi

	envs_template=""
	for env in ${envs[@]}; do
		envs_template+=" \${$env}"
	done

	envsubst < $source_file "$envs_template" > $target_file
}

# resolve all .temp files in the given path and apply the env variables to create the final .conf files

# IF USE_ENV_PREFIX=yes: 
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
resolve_conf_files $NGINX_CONF_TCP_PATH

#if exists custom file nginx.temp 
if [ -f $NGINX_CONF_TEMP_FILE ]; then
	resolve_conf "^NGINX_CONF*" $NGINX_CONF_TEMP_FILE /etc/nginx/nginx.conf
fi


exec nginx -g 'daemon off;'