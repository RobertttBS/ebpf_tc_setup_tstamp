#!/bin/bash


echo "====Compile===="
clang -O2 -target bpf -c tc-xdp-drop-tcp.c -o tc-xdp-drop-tcp.o
tc qdisc add dev veth0 clsact
tc filter add dev veth0 egress bpf da obj tc-xdp-drop-tcp.o sec tc


echo "====Load ETF qdisc===="
tc qdisc add dev veth0 root etf clockid CLOCK_TAI skip_sock_check deadline_mode