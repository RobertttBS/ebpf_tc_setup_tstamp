#!/bin/bash

NIC=enp5s0f1

tc qdisc del dev ${NIC} root etf
tc qdisc del dev ${NIC} clsact

echo "====Compile===="
clang -O2 -target bpf -c tc-setup-tstamp.bpf.c -o tc-setup-tstamp.bpf.o

echo "====Load eBPF program to test===="
tc qdisc replace dev ${NIC} clsact
tc filter add dev ${NIC} egress bpf da obj tc-setup-tstamp.bpf.o sec tc
tc qdisc add dev ${NIC} root etf clockid CLOCK_TAI skip_sock_check deadline_mode # with deadline mode
# tc qdisc add dev ${NIC} root etf clockid CLOCK_TAI skip_sock_check delta 6000000

tc qdisc show dev ${NIC}
