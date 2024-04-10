#!/bin/bash

NIC=enp5s0f1

tc qdisc del dev ${NIC} root skbprio
tc qdisc del dev ${NIC} root etf
tc qdisc del dev ${NIC} clsact
tc qdisc show dev ${NIC}