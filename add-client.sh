#!/bin/bash

if [ $# -eq 0 ]
then
	echo "must pass a client name as an arg: add-client.sh <new-client>"
else
	echo "Creating client config for: $1"
	mkdir -p clients/$1
	wg genkey | tee clients/$1/$1.priv | wg pubkey > clients/$1/$1.pub
	key=$(cat clients/$1/$1.priv) 
	ip="10.8.0."$(expr $(cat last-ip.txt | tr "." " " | awk '{print $4}') + 1)
	FQDN=$(hostname -f)
	HOSTIP=$(ip -4 addr show enp1s0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    SERVER_PUB_KEY=$(cat /etc/wireguard/server_public_key)
    cat wg0-client.example.conf | sed -e 's/:CLIENT_IP:/'"$ip"'/' | sed -e 's|:CLIENT_KEY:|'"$key"'|' | sed -e 's|:SERVER_PUB_KEY:|'"$SERVER_PUB_KEY"'|' | sed -e 's|:SERVER_ADDRESS:|'"$HOSTIP"'|' > clients/$1/wg0.conf
	echo $ip > last-ip.txt
	cp install-client.sh clients/$1/install-client.sh
	tar czvf clients/$1.tar.gz clients/$1
	echo "Created config!"
	echo "Adding peer"
	sudo wg set wg0 peer $(cat clients/$1/$1.pub) allowed-ips $ip/32
	echo "Adding peer to hosts file"
	echo $ip" "$1 | sudo tee -a /etc/hosts
	sudo wg show
	qrencode -t ansiutf8 < clients/$1/wg0.conf
	qrencode -0 clients/$1/$1.png < clients/$1/wg0.conf
fi
