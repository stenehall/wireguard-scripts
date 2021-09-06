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
	public_ip=$(curl ifconfig.io/ip -4)
    	SERVER_PUB_KEY=$(cat /etc/wireguard/server_public_key)
    	cat /etc/wireguard/wg0-client.example.conf | sed -e 's/:CLIENT_IP:/'"$ip"'/' | sed -e 's|:CLIENT_KEY:|'"$key"'|' | sed -e 's|:SERVER_PUB_KEY:|'"$SERVER_PUB_KEY"'|' | sed -e 's|:SERVER_ADDRESS:|'"$public_ip"'|' > clients/$1/wg0.conf
	echo $ip > /etc/wireguard/last-ip.txt
	cp install-client.sh clients/$1/install-client.sh
	zip -r clients/$1.zip clients/$1
	tar czvf clients/$1.tar.gz clients/$1
	echo "Created config!"
	echo "Adding peer"
	sudo wg set wg0 peer $(cat clients/$1/$1.pub) allowed-ips $ip/32
	echo "Adding peer to hosts file"
	echo $ip" "$1 | sudo tee -a /etc/hosts
	sudo wg show
	qrencode -t ansiutf8 < clients/$1/wg0.conf
	qrencode -o clients/$1/$1.png < clients/$1/wg0.conf
fi
