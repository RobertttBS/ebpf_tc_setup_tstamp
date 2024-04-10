#!/bin/bash

NIC=enp5s0f1

echo "====Compile eBPF program===="
clang -O2 -target bpf -c tc-setup-tstamp.bpf.c -o tc-setup-tstamp.bpf.o

echo "====Load eBPF program to interface===="
tc qdisc replace dev ${NIC} clsact
tc filter add dev ${NIC} egress bpf da obj tc-setup-tstamp.bpf.o sec tc

echo "====Setup TC qdsic: ETF===="
tc qdisc add dev ${NIC} root etf clockid CLOCK_TAI skip_sock_check deadline_mode # with deadline mode
# tc qdisc add dev ${NIC} root etf clockid CLOCK_TAI skip_sock_check delta 60000

tc qdisc show dev ${NIC}

