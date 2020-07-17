#!/bin/bash
  
eval "$(docopts -h - : "$@" <<EOF
Usage: $0 [--ovpn=<dir>] [--out_envfile=<file>] [--dryrun]
EOF
)"

function export_env() {
        local selected_ovpn=$1
	local outfile=$2
        local vpn_remote_line=`cat ${selected_ovpn} \
                | grep -P -o -m 1 '(?<=^remote\s)[^\n\r]+' \
                | sed -e 's~^[ \t]*~~;s~[ \t]*$~~'`
	local vpn_remote_server=`echo "${vpn_remote_line}" \
		| grep -P -o -m 1 '^[^\s\r\n]+' \
		| sed -e 's~^[ \t]*~~;s~[ \t]*$~~'`
        local vpn_port=`echo "${vpn_remote_line}" \
                | grep -P -o -m 1 '(?<=\s)\d{2,5}(?=\s)?+' \
                | sed -e 's~^[ \t]*~~;s~[ \t]*$~~'`
        local vpn_protocol=`cat "${selected_ovpn}" \
                | grep -P -o -m 1 '(?<=^proto\s)[^\r\n]+' \
                | sed -e 's~^[ \t]*~~;s~[ \t]*$~~'`
        local vpn_device_type=`cat "${selected_ovpn}" \
                | grep -P -o -m 1 '(?<=^dev\s)[^\r\n\d]+' \
                | sed -e 's~^[ \t]*~~;s~[ \t]*$~~'`

        echo "export VPN_REMOTE_SERVER=${vpn_remote_server}" >> $outfile
        echo "export VPN_PORT=${vpn_port}" >> $outfile
        echo "export VPN_PROTOCOL=${vpn_protocol}" >> $outfile
	echo "export VPN_DEVICE_TYPE=${vpn_device_type}" >> $outfile
	echo "Wrote file $outfile"
}

# $1: ovpn path
function start_vpn() {
        local ovpn_path=$1
	local outfile=$2
        local dryrun=$3
	pushd $ovpn_path
        local selected_ovpn=$(ls us-sfo* us-lax* us-las* us-sea* | shuf -n 1)
        [ -z "$selected_ovpn" ] && printf "No ovpn found!!\n" && exit 1
	echo 'OVPN selected ' ${selected_ovpn}
        if [[ "$dryrun" = "true" ]]; then
                echo 'DRYRUN: Starting openvpn...Cancelled'
                exit 0
        fi
        openvpn --config $selected_ovpn --mute-replay-warnings || exit 1 &
	sleep 10 && echo "$(curl -s -4 ifconfig.co) - $(curl -s -4 ifconfig.co/country-iso)"
        export_env $selected_ovpn $outfile
}

start_vpn $ovpn $out_envfile $dryrun
