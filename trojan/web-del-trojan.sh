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
user=$1
exp=$(grep -wE "^#& $user" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 3 | sort | uniq)
sed -i "/^#& $user $exp/,/^},{/d" /usr/local/etc/xray/config.json
rm -rf /var/www/html/trojan/trojan-$user.txt
rm -rf /user/log-trojan-$user.txt
systemctl restart xray
clear
FEEDBACK='{"status": true,"msg":"Success"}'
echo $FEEDBACK | python3 -mjson.tool
