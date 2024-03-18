

* Require `clang` to compile ebpf program.
    * `sudo apt install clang gcc-multilib -y`
* To use `bpf_ktime_get_tai_ns()` we should compile the required library from linux
    * `cd <linux kernel source code>/tools/lib/bpf`
    * `sudo make install`
    Then the program with `bpf_ktime_get_tai_ns()` can be compiled without waring.


* `sudo ./test_tc.sh` to setup environment.
* `sudo ./load_bpf2tc.sh` to compile and load ebpf program.
* `sudo ./end_test_tc.sh` to clean the environment.
