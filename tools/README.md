# cxl-reskit/tools

Once you have run the top level bootstrap script, this subdirectory will contain essential CXL-related tools.

## ndctl

The ndctl package originally contained only tools for administering NVDIMMs and other non-volatile memory.
These tools are now being generalized to also support CXL memory devices.

The [ndctl repository](https://github.com/pmem/ndctl/) now provides a set of command line tools:

- `cxl-cli` - lists CXL memory devices and metadata
- `daxctl` - configures memory devices for Device DAX mode
- `ndctl` - performs configuration and management commands specific to non-volatile memory

The ndctl repository also provides a set of C libraries that correspond to each of the command line tools:

- `libcxl`
- `libdaxctl`
- `libndctl`

## MLC

One valuable tool is the Memory Latency Checker (MLC) program from Intel. It is not
open source, but can be freely downloaded from [this website](https://www.intel.com/content/www/us/en/developer/articles/tool/intelr-memory-latency-checker.html).

The bootstrap script downloads this tool automatically. It is required in order to run the examples that use `mlc`.

## Usage Examples

### Convert Special Purpose Memory to "Online" Memory

For this operation, may need to install the following prerequisites:

- `numactl`
- `daxctl` - needs to be built from the tools/ndctl repository, as packaged versions are not new enough. (TODO: verify)

Use `numastat` to observe current NUMA topology of your system. This example is from a single-socket system:

```text
[root@hostname ~]# numastat
                 node0
numa_hit       5493270
numa_miss            0
numa_foreign         0
interleave_hit   14593
local_node     5493269
other_node           0
```

Use daxctl to "online" the memory:

```shell
daxctl reconfigure-device --mode=system-ram --region=0 dax0.0
daxctl reconfigure-device --mode=system-ram --region=0 --force dax0.0
```

Example output:

```text
[root@hostname ~]# daxctl reconfigure-device --mode=system-ram --region=0 dax0.0
dax0.0: error: kernel policy will auto-online memory, aborting
error reconfiguring devices: Device or resource busy
reconfigured 0 devices

[root@hostname ~]# daxctl reconfigure-device --mode=system-ram --region=0 --force dax0.0
dax0.0:
WARNING: detected a race while onlining memory
Some memory may not be in the expected zone. It is
recommended to disable any other onlining mechanisms,
and retry. If onlining is to be left to other agents,
use the --no-online option to suppress this warning
dax0.0: all memory sections (256) already online
[
  {
    "chardev":"dax0.0",
    "size":34359738368,
    "target_node":1,
    "align":2097152,
    "mode":"system-ram",
    "online_memblocks":256,
    "total_memblocks":256,
    "movable":false
  }
]
reconfigured 1 device
```

Now run `numastat` again; you should see an additional NUMA node:

```text
[root@hostname ~]# numastat
                  node0 node1
numa_hit        8080981     0
numa_miss             0     0
numa_foreign          0     0
interleave_hit    14593     0
local_node      8080981     0
other_node            0     0
```

### Run MLC to Test Memory Bandwidth and Latency

Assuming you have already "onlined" your CXL memory as a NUMA node, you can test bandwidth and latency with Intel's Memory Latency Checker (`mlc`).

```shell
./mlc --latency_matrix
./mlc --bandwidth_matrix
```

Example output:

```text
[root@hostname ~]# ./mlc --latency_matrix
Intel(R) Memory Latency Checker - v3.9
Command line parameters: --latency_matrix

Using buffer size of 2000.000MiB
Measuring idle latencies (in ns)...
                Numa node
Numa node            0       1
       0          84.5   564.5

[root@hostname ~]# ./mlc --bandwidth_matrix
Intel(R) Memory Latency Checker - v3.9
Command line parameters: --bandwidth_matrix

Using buffer size of 100.000MiB/thread for reads and an additional 100.000MiB/thread for writes
Measuring Memory Bandwidths between nodes within system
Bandwidths are in MB/sec (1 MB/sec = 1,000,000 Bytes/sec)
Using all the threads from each core if Hyper-threading is enabled
Using Read-only traffic type
                Numa node
Numa node            0       1
       0        30562.8  4795.3
```
