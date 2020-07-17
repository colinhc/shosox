#!/bin/bash

_outfile=/tmp/vpnenv
./random-vpn.sh --ovpn=/ovpn-files --out_envfile=$_outfile
./iptables.sh
sleep infinity
