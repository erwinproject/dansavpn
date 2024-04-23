RANTEXT=`openssl rand -hex 12`
CURRENTEPOCTIME=TJ$RANTEXT
SNIBUG=$1

clear
domain=$(cat /usr/local/etc/xray/domain)
user=${CURRENTEPOCTIME}
masaaktif=3
pwtr=$(openssl rand -hex 8)
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#trojan$/a\#& '"$user $exp"'\
},{"password": "'""$pwtr""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#trojan-tcp$/a\#& '"$user $exp"'\
},{"password": "'""$pwtr""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
sed -i '/#trojan-grpc$/a\#& '"$user $exp"'\
},{"password": "'""$pwtr""'","email": "'""$user""'"' /usr/local/etc/xray/config.json
trojanlink1="trojan://$pwtr@$SNIBUG:443?path=/trojan&security=tls&host=$domain&type=ws&sni=$domain#$user"
trojanlink2="trojan://${pwtr}@$SNIBUG:80?path=/trojan&security=none&host=$domain&type=ws#$user"
trojanlink3="trojan://${pwtr}@$domain:443?security=tls&encryption=none&type=grpc&serviceName=trojan-grpc&sni=$domain#$user"
trojanlink4="trojan://${pwtr}@$domain:443?security=tls&type=tcp&sni=$SNIBUG#$user"
cat > /var/www/html/trojan/trojan-$user.txt << END
==========================
    Link Trojan Account
==========================
Link TLS  : trojan://$pwtr@$SNIBUG:443?path=/trojan&security=tls&host=$domain&type=ws&sni=$domain#$user
==========================
Link NTLS : trojan://${pwtr}@$SNIBUG:80?path=/trojan&security=none&host=$domain&type=ws#$user
==========================
Link gRPC : trojan://${pwtr}@$domain:443?security=tls&encryption=none&type=grpc&serviceName=trojan-grpc&sni=$domain#$user
==========================
Link TCP : trojan://${pwtr}@$domain:443?security=tls&type=tcp&sni=$SNIBUG#$user
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
END
ISP=$(cat /usr/local/etc/xray/org)
CITY=$(cat /usr/local/etc/xray/city)
systemctl restart xray
clear
echo -e "————————————————————————————————————————————————————" | tee -a /user/log-trojan-$user.txt
echo -e "                   Trojan Account                  " | tee -a /user/log-trojan-$user.txt
echo -e "————————————————————————————————————————————————————" | tee -a /user/log-trojan-$user.txt
echo -e "Remarks       : ${user}" | tee -a /user/log-trojan-$user.txt
echo -e "ISP           : $ISP" | tee -a /user/log-trojan-$user.txt
echo -e "City          : $CITY" | tee -a /user/log-trojan-$user.txt
echo -e "Host/IP       : ${domain}" | tee -a /user/log-trojan-$user.txt
echo -e "Port TLS      : 443" | tee -a /user/log-trojan-$user.txt
echo -e "Port NTLS     : 80" | tee -a /user/log-trojan-$user.txt
echo -e "Port gRPC     : 443" | tee -a /user/log-trojan-$user.txt
echo -e "Password      : ${pwtr}" | tee -a /user/log-trojan-$user.txt
echo -e "Network       : TCP, Websocket, gRPC" | tee -a /user/log-trojan-$user.txt
echo -e "Path          : /trojan" | tee -a /user/log-trojan-$user.txt
echo -e "ServiceName   : trojan-grpc" | tee -a /user/log-trojan-$user.txt
echo -e "Alpn          : h2, http/1.1" | tee -a /user/log-trojan-$user.txt
echo -e "————————————————————————————————————————————————————" | tee -a /user/log-trojan-$user.txt
echo -e "Link TLS      : ${trojanlink1}" | tee -a /user/log-trojan-$user.txt
echo -e "————————————————————————————————————————————————————" | tee -a /user/log-trojan-$user.txt
echo -e "Link NTLS     : ${trojanlink2}" | tee -a /user/log-trojan-$user.txt
echo -e "————————————————————————————————————————————————————" | tee -a /user/log-trojan-$user.txt
echo -e "Link gRPC     : ${trojanlink3}" | tee -a /user/log-trojan-$user.txt
echo -e "————————————————————————————————————————————————————" | tee -a /user/log-trojan-$user.txt
echo -e "Link TCP      : ${trojanlink4}" | tee -a /user/log-trojan-$user.txt
echo -e "————————————————————————————————————————————————————" | tee -a /user/log-trojan-$user.txt
# echo -e "Format Clash  : https://$domain/trojan/trojan-$user.txt" | tee -a /user/log-trojan-$user.txt
# echo -e "————————————————————————————————————————————————————" | tee -a /user/log-trojan-$user.txt
# echo -e "Expired On    : $exp" | tee -a /user/log-trojan-$user.txt
# echo -e "————————————————————————————————————————————————————" | tee -a /user/log-trojan-$user.txt
# echo " " | tee -a /user/log-trojan-$user.txt
# echo " " | tee -a /user/log-trojan-$user.txt
# echo " " | tee -a /user/log-trojan-$user.txt
# read -n 1 -s -r -p "Press any key to back on menu"

# echo -e "https://$domain/trojan/trojan-$user.txt"