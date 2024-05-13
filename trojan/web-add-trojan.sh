NC='\e[0m'
DEFBOLD='\e[39;1m'
RB='\e[31;1m'
GB='\e[32;1m'
YB='\e[33;1m'
BB='\e[34;1m'
MB='\e[35;1m'
CB='\e[35;1m'
WB='\e[37;1m'
clear
RANTEXT=`openssl rand -hex 12`
CURRENTEPOCTIME=$RANTEXT
domain=$(cat /usr/local/etc/xray/domain)
user=${CURRENTEPOCTIME}
masaaktif=$1
# uuid=$(cat /proc/sys/kernel/random/uuid)
pwtr=$(openssl rand -hex 4)-$(openssl rand -hex 2)-$(openssl rand -hex 2)-$(openssl rand -hex 2)-$(openssl rand -hex 6)
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#trojan$/a\#& '"$user $exp"'\
},{"password": "'""$pwtr""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#trojan-tcp$/a\#& '"$user $exp"'\
},{"password": "'""$pwtr""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#trojan-grpc$/a\#& '"$user $exp"'\
},{"password": "'""$pwtr""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
trojanlink1="trojan://$pwtr@$domain:443?path=/trojan&security=tls&host=$domain&type=ws&sni=$domain#$user"
trojanlink2="trojan://${pwtr}@$domain:80?path=/trojan&security=none&host=$domain&type=ws#$user"
trojanlink3="trojan://${pwtr}@$domain:443?security=tls&encryption=none&type=grpc&serviceName=trojan-grpc&sni=$domain#$user"
trojanlink4="trojan://${pwtr}@$domain:443?security=tls&type=tcp&sni=$domain#$user"
cat > /var/www/html/trojan/trojan-$user.txt << END
==========================
    Trojan WS (CDN) TLS
==========================
- name: Trojan-$user
  server: $domain
  port: 443
  type: trojan
  password: $pwtr
  network: ws
  servername: $domain
  skip-cert-verify: true
  udp: true
  ws-opts:
    path: /trojan
    headers:
      Host: $domain
==========================
    Trojan gRPC (CDN)
==========================
- name: Trojan-$user
  server: $domain
  port: 443
  type: trojan
  password: $pwtr
  network: grpc
  servername: $domain
  skip-cert-verify: true
  udp: true
  grpc-opts:
    grpc-service-name: "trojan-grpc"
==========================
        Trojan TCP
==========================
- name: Trojan-$user
  server: $domain
  port: 443
  type: trojan
  password: $pwtr
  skip-cert-verify: true
  servername: $domain
  udp: true
==========================
    Link Trojan Account
==========================
Link TLS  : trojan://$pwtr@$domain:443?path=/trojan&security=tls&host=$domain&type=ws&sni=$domain#$user
==========================
Link NTLS : trojan://${pwtr}@$domain:80?path=/trojan&security=none&host=$domain&type=ws#$user
==========================
Link gRPC : trojan://${pwtr}@$domain:443?security=tls&encryption=none&type=grpc&serviceName=trojan-grpc&sni=$domain#$user
==========================
Link TCP : trojan://${pwtr}@$domain:443?security=tls&type=tcp&sni=$domain#$user
==========================
END
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
systemctl restart xray
clear
GENERATEACCOUNT='{"id":"'${user}'","server":"'${domain}'","password": "'${pwtr}'","path": "/trojan","port_tls": 443, "port_ntls": 80, "port_grcp": 433,"link": "trojan/trojan-'$user'.txt"}'
echo $GENERATEACCOUNT | python3 -mjson.tool
