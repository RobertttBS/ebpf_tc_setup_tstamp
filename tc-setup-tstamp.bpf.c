// tc-xdp-drop-tcp.c

#include <linux/bpf.h>
#include <linux/pkt_cls.h>

#include <bpf/bpf_helpers.h>

SEC("tc")
int tc_setup_tstamp(struct __sk_buff *skb)
{
    unsigned long now = bpf_ktime_get_tai_ns(), delay = 100000; // 1ms default
    delay = (skb->priority) ? skb->priority : delay;
    delay += (delay << 25) + 1000000;
    skb->tstamp = now + delay; // priority is in microseconds

    bpf_printk("skb->tstamp %llu, skb->priority %d, diff %llu, packet len %d\n", skb->tstamp, skb->priority, delay, skb->len);
    return TC_ACT_OK;
}

char _license[] SEC("license") = "GPL";