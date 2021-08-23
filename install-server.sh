# Install wireguard on Ubuntu Server
# (C) 2021 Richard Dawson 

# Ubuntu
sudo apt-get update
sudo apt-get -y install wireguard

sudo apt-get install -y qrencode

#Create Server Keys
sudo sudo
cd /etc/wireguard
wg genkey | tee server_private_key | wg pubkey > server_public_key

# Get config
wget https://raw.githubusercontent.com/rdbh/wireguard-scripts/master/wg0-server.example.conf /etc/wireguard/wg0.conf
