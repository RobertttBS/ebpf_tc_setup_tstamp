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
int tc_priority_from_tos(struct __sk_buff *skb)
{
    void *data = (void *) (long) skb->data;
    void *data_end = (void *) (long) skb->data_end;
    struct eth_hdr *eth = data;
    struct iphdr *iph = data + sizeof(*eth);

    if (data + sizeof(*eth) + sizeof(*iph) > data_end)
        return TC_ACT_OK;
    if (eth->h_proto != bpf_htons(ETH_P_IP))
        return TC_ACT_OK;

    skb->priority = iph->tos;
    return TC_ACT_OK;
}

char _license[] SEC("license") = "GPL";