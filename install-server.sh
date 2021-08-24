# Install wireguard on Ubuntu Server
# (C) 2021 Richard Dawson 

# Ubuntu
sudo apt-get update
sudo apt-get -y install wireguard

sudo apt-get install -y qrencode

# Create Server Keys
cd /etc/wireguard
sudo wg genkey | tee server_private_key | wg pubkey > server_public_key

# Get config
sudo wget https://raw.githubusercontent.com/rdbh/wireguard-scripts/master/wg0-server.example.conf 

# Add server key to config
SERVER_PUB_KEY=$(cat /etc/wireguard/server_public_key)
cat wg0-server.example.conf | sed -e 's|:SERVER_KEY:|'"$SERVER_PUB_KEY"'|' > etc/wireguard/wg0.conf

# Get run scripts/master/wg0-server
cd ~
wget https://raw.githubusercontent.com/rdbh/wireguard-scripts/master/add-client.sh
chmod +x add-client.sh
wget https://raw.githubusercontent.com/rdbh/wireguard-scripts/master/install-client.sh
chmod +x install-client.sh
wget https://raw.githubusercontent.com/rdbh/wireguard-scripts/master/remove-peer.sh
chmod +x remove-peer.sh

# Start up server
sudo wg-quick up wg0