#!/bin/bash

# Can only be run by root
if [[ "$EUID" -ne 0 ]]; then
  echo "ERROR: This script must be run as root." >&2
  exit 1
fi

dnf install -y iptables-services
systemctl enable iptables && systemctl start iptables
iptables -I INPUT 1 -p tcp -s <ip address> --dport <port> -m conntrack --ctstate NEW -j ACCEPT
iptables -I INPUT 2 -p tcp --dport <port> -j REJECT --reject-with tcp-reset
service iptables save

iptables -L INPUT -n --line-numbers
