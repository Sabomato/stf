PUBLIC_ADDR=$(ifconfig eth0 | grep 'inet ' | awk '{print $2}')


<<com
required LDAP parameters:
	
--ldap-search-dn "ou=mathematicians,dc=example,dc=com"
--ldap-search-field "test"
--ldap-url ldap://ldap.forumsys.com:389 
--ldap-username-field[cn]
--secret
--app-url
com


stf migrate
(stf triproxy app001 --bind-pub tcp://127.0.0.1:7111 --bind-dealer tcp://127.0.0.1:7112 --bind-pull tcp://127.0.0.1:7113)&
(stf triproxy dev001 --bind-pub tcp://$PUBLIC_ADDR:7114 --bind-dealer tcp://127.0.0.1:7115 --bind-pull tcp://$PUBLIC_ADDR:7116)&
(stf processor proc001 --connect-app-dealer tcp://127.0.0.1:7112 --connect-dev-dealer tcp://127.0.0.1:7115)&
(stf processor proc002 --connect-app-dealer tcp://127.0.0.1:7112 --connect-dev-dealer tcp://127.0.0.1:7115)&
(stf reaper reaper001 --connect-push tcp://127.0.0.1:7116 --connect-sub tcp://127.0.0.1:7111)&


#(stf auth-mock --port 7120 --secret kute kittykat --app-url http://$PUBLIC_ADDR:7100/)&
bash  ./auth-run-script.sh 

bash ./device-host-run-script.sh

(stf app --port 7105 --secret kute kittykat --auth-url http://$PUBLIC_ADDR:7100/auth/ldap/ --websocket-url http://$PUBLIC_ADDR:7110/)&
(stf api --port 7106 --secret kute kittykat --connect-push tcp://127.0.0.1:7113 --connect-sub tcp://127.0.0.1:7111 --connect-push-dev tcp://127.0.0.1:7116 --connect-sub-dev tcp://127.0.0.1:7114)&
(stf groups-engine --connect-push tcp://127.0.0.1:7113 --connect-sub tcp://127.0.0.1:7111 --connect-push-dev tcp://127.0.0.1:7116 --connect-sub-dev tcp://127.0.0.1:7114)&
(stf websocket --port 7110 --secret kute kittykat --storage-url http://localhost:7100/ --connect-sub tcp://127.0.0.1:7111 --connect-push tcp://127.0.0.1:7113)&
(stf storage-temp --port 7102)&
(stf storage-plugin-image --port 7103 --storage-url http://localhost:7100/)&
(stf storage-plugin-apk --port 7104 --storage-url http://localhost:7100/)&
(stf poorxy --port 7100 --app-url http://localhost:7105/ --auth-url http://localhost:7120/ --api-url http://localhost:7106/ --websocket-url http://localhost:7110/ --storage-url http://localhost:7102/ --storage-plugin-image-url http://localhost:7103/ --storage-plugin-apk-url http://localhost:7104/)
 pkill -9 node
