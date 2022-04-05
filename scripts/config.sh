
export SECRET="kute kittykat"
export DEFAULT_APP_IP=$(ifconfig eth0 | grep 'inet ' | awk '{print $2}')
export DEFAULT_APP_PORT="7100"