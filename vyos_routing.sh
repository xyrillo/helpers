#!/bin/vbash
#VyOS config for routing protocol testing
#set interfaces ethernet eth2 address dhcp
#scp vyos@10.0.100.1:/home/vyos/conf.sh
#https://raw.githubusercontent.com/xyrillo/helpers/refs/heads/main/vyos_routing.sh
#vyos_routing.sh
source /opt/vyatta/etc/functions/script-template

#Prompts
echo -n "Enter network ID: "
read NETID
show interfaces ethernet
echo -n "Upstream interface: "
read INT_UP
echo -n "Downstream interface: "
read INT_DN

#Enter config mode
configure

#System
#Set host name to netid
set system host-name Vy$NETID

#DNS
set system name-server 192.168.1.53

#Enable remote logging
set system syslog host log.xyrill.com facility all level all
set system syslog host log.xyrill.com protocol udp
set system syslog host log.xyrill.com format include-timezone

#Interfaces
	#Get DHCP on upstream interface
#set interfaces ethernet $INT_UP address dhcp
	#Set netid to down stream interface
set interfaces ethernet $INT_DN address 10.0.$NETID.1/24

#DHCP network behind second interface
set service dhcp-server hostfile-update
#set service dhcp-server shared-network-name 'v100' option domain-name 'v.100'
set service dhcp-server shared-network-name $NETID option name-server 192.168.1.53
set service dhcp-server listen-address 10.0.$NETID.1
set service dhcp-server shared-network-name $NETID authoritative
set service dhcp-server shared-network-name $NETID subnet 10.0.$NETID.0/24 subnet-id 1
set service dhcp-server shared-network-name $NETID subnet 10.0.$NETID.0/24 lease 86400
set service dhcp-server shared-network-name $NETID subnet 10.0.$NETID.0/24 range 50 start 10.0.$NETID.2
set service dhcp-server shared-network-name $NETID subnet 10.0.$NETID.0/24 range 50 stop 10.0.$NETID.50

#Enable SSHD
set service ssh port 22
set service ssh listen-address 0.0.0.0


#Routing

#RIP
set protocols rip interface $INT_UP
set protocols rip interface $INT_DN
set protocols rip default-information originate
#set protocols rip neighbor 10.0.100.1


#IS-IS
	#AFI: 49
	#Area ID: .0001 - area number, 0002, 0003, etc
	#System ID: IP in 0000.0000.0000 format w/ zeroes
		#10.0.100.1 = 0100.0010.0001
	#NET: .00
#echo "Example: 0100.0010.0001"
#echo "Example: 0100.0010.1001"
#echo -n "Enter IS-IS System ID: "
#read ISID
#set protocols isis net 49.0001.$ISID.00
#set protocols isis dynamic-hostname
#set protocols isis level level-1-2
#set protocols isis lsp-mtu 4352
#set protocols isis metric-style wide
#set protocols isis name default-information originate ipv4 level-1
#set protocols isis name default-information originate ipv4 level-2





