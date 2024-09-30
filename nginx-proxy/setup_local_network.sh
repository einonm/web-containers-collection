#! /bin/sh
#
# This script takes one parameter either 'add' or 'del', which adds or removes
# the network configuration required to route some hardcoded MACs and IPs
# given by a VM registration to assign a VM to a host.
#
# Doing this enables multiple docker container services to be routed via
# nginx-proxy on the host, all using port 80/443
#
# Author: Mark Einon <mark.einon@gmail.com>

NETDEV=eno1
NAMES=("devops1_macvlan" "devops2_macvlan")

declare -A IPS
declare -A MACS

# devops1@example.com registration
IPS[${NAMES[0]}]="10.1.1.0"
MACS[${NAMES[0]}]="01:00:5E:00:00:00"

# devops2@example.com registration
IPS[${NAMES[1]}]="10.1.1.1"
MACS[${NAMES[2]}]="01:00:5E:00:00:01"

for NAME in ${NAMES[@]}; do
    if [ $1 = 'add' ]; then
        echo "Adding $NAME with MAC ${MACS[${NAME}]}, IP ${IPS[${NAME}]}"
        ip link add $NAME link $NETDEV addr ${MACS[$NAME]} type macvlan mode bridge
        ip address add ${IPS[$NAME]}/32 dev $NAME
        ip link set $NAME up
        ip route add ${IPS[$NAME]}/32 dev $NAME
    fi

    if [ $1 = 'del' ]; then
        echo "Removing $NAME with MAC ${MACS[${NAME}]}, IP ${IPS[${NAME}]}"
        ip link delete $NAME link $NETDEV type macvlan mode bridge
    fi
done
