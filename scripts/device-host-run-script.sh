
source "config.sh"






if [ $# == 1 ]
then
    APP_IP=$1
    APP_URL="http://$APP_IP:$DEFAULT_APP_PORT/"
    (stf poorxy --port 7100 --app-url http://$APP_IP:$DEFAULT_APP_PORT/ --auth-url http://$AUTH_ADDR:7120/ --api-url http://$APP_IP:7106/ --websocket-url http://$WEB_SOCKET_ADDR:7110/ --storage-url http://$DB_ADDR:7102/ --storage-plugin-image-url http://$DB_ADDR:7103/ --storage-plugin-apk-url http://$DB_ADDR:7104/)
    echo
else    #no arguments provided, it's assumed everything is running on the same machine, so no poorxy required
    APP_IP=$DEFAULT_APP_IP
    APP_URL="http://$APP_IP:$DEFAULT_APP_PORT/"
    echo "App ip not provided,default url is \"$APP_URL\""

fi

DB_ADDR=$APP_IP
WEB_SOCKET_ADDR=$APP_IP
AD_HOST_ADDR="127.0.0.1"
ADB_PORT="5037"
PUBLIC_ADDR=$(ifconfig eth0 | grep 'inet ' | awk '{print $2}')



(stf provider --name $(hostname) --min-port 7400 --max-port 7700 --connect-sub tcp://$APP_IP:7114 --connect-push tcp://$APP_IP:7116 --group-timeout 900 --public-ip $DEFAULT_APP_IP --storage-url http://$APP_IP:7100/ --adb-host $AD_HOST_ADDR --adb-port $ADB_PORT --vnc-initial-size 600x800 --mute-master never --allow-remote)&

