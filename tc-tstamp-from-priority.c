// tc-xdp-drop-tcp.c
#include <stdbool.h>
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/in.h>
#include <linux/pkt_cls.h>

#include <bpf/bpf_endian.h>
#include <bpf/bpf_helpers.h>

struct eth_hdr {
    unsigned char h_dest[ETH_ALEN];
    unsigned char h_source[ETH_ALEN];
    unsigned short h_proto;
};

SEC("tc")
int tc_drop_tcp(struct __sk_buff *skb)
{
    skb->tstamp = bpf_ktime_get_ns() + skb->priority * 1000000;

    return TC_ACT_OK;
}

char _license[] SEC("license") = "GPL";