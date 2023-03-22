#!/bin/sh

echo ""
cd ~/ikev2-pptp-pihole-unbound-i2pd-xd-torrent-client/
docker-compose exec pihole sh -c "echo '>top-domains (10)' | nc 127.0.0.1 4711"
free -h
echo ""
df -h
echo ""
docker stats --no-stream
echo ""
doas /usr/sbin/iptables -L -v | grep set
echo ""
