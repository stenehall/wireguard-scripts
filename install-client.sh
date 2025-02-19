# Install instructions for clients created by add-client.sh
# (C) 2021 Richard Dawson 

# Ubuntu
sudo add-apt-repository ppa:wireguard/wireguard

# Debian
#echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
#printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable

#Both
sudo apt-get update && sudo apt-get install wireguard

# put wg0.conf in `/etc/wireguard/`
cat wg0.conf | sudo tee /etc/wireguard/wg0.conf

# start wireguard wg0
sudo wg-quick up wg0

# (optional) set wireguard wg0 to start on boot
sudo systemctl enable wg-quick@wg0.service

