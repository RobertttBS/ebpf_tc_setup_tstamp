// tc-xdp-drop-tcp.c
#include <stdbool.h>
#include <linux/bpf.h>
#include <linux/in.h>
#include <linux/pkt_cls.h>

#include <bpf/bpf_endian.h>
#include <bpf/bpf_helpers.h>

SEC("tc")
int tc_drop_tcp(struct __sk_buff *skb)
{
    skb->tstamp = bpf_ktime_get_ns() + skb->priority + 1000; // priority is in microseconds

    return TC_ACT_OK;
}

char _license[] SEC("license") = "GPL";