#!/bin/sh

while :
do

echo "Processing"

docker cp ikev2-pptp-pihole-unbound-i2pd-xd-torrent-client-pihole-1:/etc/pihole/pihole-FTL.db /home/git/

sqlite3 /home/git/pihole-FTL.db "select client from queries where domain like 'peacecorps.gov' or domain like 'higi.com' group by client;" > /home/git/blocked_br

sed 's/.*/ipset add myset-ip &/' /home/git/blocked_br > /home/git/block_list.sh

cat << EOF > /home/git/ikev2-pptp-pihole-unbound-i2pd-xd-torrent-client/block_list_ip.sh
#!/bin/sh

iptables -D DOCKER-USER -m set --match-set myset-ip src -j DROP
iptables -D INPUT -m set --match-set myset-ip src -j DROP

ipset destroy myset-ip
ipset create myset-ip hash:ip maxelem 262144

EOF

cat /home/git/block_list.sh >> /home/git/ikev2-pptp-pihole-unbound-i2pd-xd-torrent-client/block_list_ip.sh

cat << EOF >> /home/git/ikev2-pptp-pihole-unbound-i2pd-xd-torrent-client/block_list_ip.sh

ipset save > /etc/ipset.rules

iptables -I DOCKER-USER -m set --match-set myset-ip src -j DROP
iptables -A INPUT -m set --match-set myset-ip src -j DROP
EOF

sed -i '/ipset add myset-ip 172.29.0.1/d' /home/git/ikev2-pptp-pihole-unbound-i2pd-xd-torrent-client/block_list_ip.sh
sed -i '/ipset add myset-ip ::/d' /home/git/ikev2-pptp-pihole-unbound-i2pd-xd-torrent-client/block_list_ip.sh

rm /home/git/pihole-FTL.db
rm /home/git/blocked_br
rm /home/git/block_list.sh

cd /home/git/ikev2-pptp-pihole-unbound-i2pd-xd-torrent-client
git diff --stat
date
./block_list_ip.sh
date
dig eth0.me @172.29.0.1 +short
echo "Waiting 24h"
sleep 24h

done
