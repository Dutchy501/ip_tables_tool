#!/bin/bash

# Can only be run by root
if [[ "$EUID" -ne 0 ]]; then
  echo "ERROR: This script must be run as root." >&2
  exit 1
fi

yum install -y iptables-services
systemctl enable --now iptables
iptables -F
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -s <ip address> --dport <port> -j ACCEPT
#Add this to drop all other connections on the same port from different ipaddresses
iptables -A INPUT -p tcp --dport <port> -j DROP
service iptables save

iptables -L INPUT -n --line-numbers
