#!/bin/bash


tc qdisc del dev enp5s0f1 root etf
tc qdisc del dev enp5s0f1 clsact