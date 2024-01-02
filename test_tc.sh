#!/bin/bash

UE0=192.168.1.1
UE1=192.168.1.2
UE0_IPV6=2001:db8::1
UE1_IPV6=2001:db8::2
VETH0_ETH_ADDR=aa:bb:cc:dd:ee:ff
VETH1_ETH_ADDR=aa:bb:cc:dd:ee:f1

# Create a new network namespace
ip netns add ns2

# Create two veth interfaces
ip link add veth0 type veth peer name veth1

# Move veth1 to the new namespace
ip link set veth1 netns ns2

echo "====Assign IP addresses to the veth interfaces===="
ip addr add ${UE0}/24 dev veth0
ip netns exec ns2 ip addr add ${UE1}/24 dev veth1
# ip addr change ${UE0_IPV6}/64 dev veth0
# ip netns exec ns2 ip addr change ${UE1_IPV6}/64 dev veth1

echo "====Setup mac address===="
ip link set dev veth0 address ${VETH0_ETH_ADDR}
ip netns exec ns2 ip link set dev veth1 address ${VETH1_ETH_ADDR}

# echo "====Disable ipv6===="
# sysctl -w net.ipv6.conf.all.disable_ipv6=1
# sysctl -w net.ipv6.conf.default.disable_ipv6=1
# sysctl -w net.ipv6.conf.lo.disable_ipv6=1


echo "====Enable the veth interfaces===="
ip link set veth0 up
ip netns exec ns2 ip link set veth1 up

echo "====Setup arp address===="
arp -s ${UE1} ${VETH1_ETH_ADDR}
ip netns exec ns2 arp -s ${UE0} ${VETH0_ETH_ADDR}

echo "====Show the mac address===="
arp -a -n
ip netns exec ns2 arp -a -n

echo "====Setup default route===="
ip -6 route add ::/0 dev veth0
ip netns exec ns2 ip -6 route add ::/0 dev veth1
ip -6 route


# echo "====Setup TC===="
# tc qdisc replace dev veth0 root etf clockid CLOCK_TAI skip_sock_check deadline_mode
# ip netns exec ns2 tc qdisc replace dev veth1 root etf clockid CLOCK_TAI skip_sock_check deadline_mode
# tc qdisc show dev veth0
# ip netns exec ns2 tc qdisc show dev veth1

# Test connectivity between the two IP addresses
ping -c 3 -I 192.168.1.1 192.168.1.2
ip netns exec ns2 ping -c 3 192.168.1.1

# Remove the veth interfaces and network namespace
# ip link delete veth0
# ip netns delete ns2