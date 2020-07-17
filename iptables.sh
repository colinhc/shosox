#!/bin/bash
# Forked from binhex's OpenVPN dockers

# Wait until tunnel is up
function block_on_vpn() {
	while : ; do
		tunnelstat=$(netstat -ie | grep -E "tun|tap")
		if [[ ! -z "${tunnelstat}" ]]; then
			echo "Found tun | tap !"
			break
		else
			echo "No tun|tap found!!"
			sleep 1
		fi
	done
}


block_on_vpn

# Get default gateway of interfaces as looping through them
DEFAULT_GATEWAY=$(ip -4 route list 0/0 | cut -d ' ' -f 3)
ip route add "${LAN_NETWORK}" via "${DEFAULT_GATEWAY}" dev eth0

echo "IP via VPN: $(curl -s ifconfig.co)"
