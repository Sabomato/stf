
source "config.sh"

LDAP_SEARCH_DN="dc=example,dc=com"
LDAP_SEARCH_FIELD="uid"
LDAP_URL="ldap://ldap.forumsys.com:389"
LDAP_BIND_DN="cn=read-only-admin,dc=example,dc=com"
LDAP_BIND_CREDENTIALS="password" 


<<com
required LDAP parameters:
	
--ldap-search-dn "ou=mathematicians,dc=example,dc=com"
--ldap-search-field "test"
--ldap-url ldap://ldap.forumsys.com:389 
--ldap-username-field[cn]
--secret
--app-url
com


if [ $# -eq 1 ] 
then
    APP_URL=$1
else   
    APP_URL="http://$DEFAULT_APP_IP:$DEFAULT_APP_PORT/"
    echo "App url not provided, using \"$APP_URL\""
fi


(stf auth-ldap --port 7120 --secret $SECRET --ldap-bind-credentials $LDAP_BIND_CREDENTIALS --ldap-bind-dn $LDAP_BIND_DN --ldap-search-field $LDAP_SEARCH_FIELD --ldap-search-dn $LDAP_SEARCH_DN --ldap-url $LDAP_URL  --app-url $APP_URL)&


