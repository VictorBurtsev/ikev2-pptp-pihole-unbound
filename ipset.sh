#!/bin/sh

iptables -D DOCKER-USER -m set --match-set geoblock-br src -j DROP
iptables -D INPUT -m set --match-set geoblock-br src -j DROP

for country in br
do
    ipset destroy geoblock-$country > /dev/null 2>&1
    ipset create geoblock-$country hash:net
    for IP in $(wget -O - http://www.ipdeny.com/ipblocks/data/countries/$country.zone)
    do
        ipset add geoblock-$country $IP
    done
done

ipset add geoblock-br 179.48.86.0/24

ipset add geoblock-br 177.85.8.0/24
ipset add geoblock-br 177.85.10.0/24
ipset add geoblock-br 177.85.11.0/24

ipset add geoblock-br 190.83.50.0/24

ipset add geoblock-br 201.218.170.0/24

ipset add geoblock-br 201.216.64.0/24
ipset add geoblock-br 201.216.66.0/24
ipset add geoblock-br 201.216.67.0/24

ipset add geoblock-br 187.120.164.0/24
ipset add geoblock-br 187.120.165.0/24
ipset add geoblock-br 187.120.166.0/24


ipset save > /etc/ipset.rules

iptables -I DOCKER-USER -m set --match-set geoblock-br src -j DROP
iptables -A INPUT -m set --match-set geoblock-br src -j DROP

watch "iptables -L -v | grep 'geoblock-br'"
