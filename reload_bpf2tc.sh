#!/bin/bash


tc qdisc del dev enp5s0f1 root etf
# tc qdisc del dev enp5s0f1 root skbprio
tc qdisc del dev enp5s0f1 clsact

echo "====Compile===="
clang -O2 -target bpf -c tc-setup-tstamp.bpf.c -o tc-setup-tstamp.bpf.o

# echo "====Load eBPF program to veth0===="
# tc qdisc add dev veth0 clsact
# tc filter add dev veth0 egress bpf da obj tc-xdp-drop-tcp.o sec tc

# echo "====Load eBPF program to test===="
# tc qdisc add dev test clsact
# tc filter add dev test egress bpf da obj tc-xdp-drop-tcp.o sec tc
# tc qdisc add dev test root etf clockid CLOCK_TAI skip_sock_check deadline_mode

echo "====Load eBPF program to test===="
tc qdisc replace dev enp5s0f1 clsact
tc filter add dev enp5s0f1 egress bpf da obj tc-setup-tstamp.bpf.o sec tc
tc qdisc add dev enp5s0f1 root etf clockid CLOCK_TAI skip_sock_check deadline_mode # with deadline mode
# tc qdisc add dev enp5s0f1 root etf clockid CLOCK_TAI skip_sock_check delta 60000

# tc qdisc add dev enp5s0f1 root handle 1: skbprio

tc qdisc show dev enp5s0f1


# echo "====Load ETF qdisc===="
# tc qdisc add dev veth0 root etf clockid CLOCK_TAI skip_sock_check deadline_mode
# tc qdisc add dev veth0 root fq

# ping -c 3 -I 192.168.1.1 192.168.1.2
# ip netns exec ns2 ping -c 3 192.168.1.1
