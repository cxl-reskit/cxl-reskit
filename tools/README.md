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

One valuable tool for understanding memory performance is the Memory Latency Checker (MLC) program from Intel.
It is not open source, but can be freely downloaded from
[this website](https://www.intel.com/content/www/us/en/developer/articles/tool/intelr-memory-latency-checker.html).
The `bootstrap.sh` script downloads it automatically.

To use MLC with CXL memory, it is necessary to have the device in System RAM mode.
See [Converting Between Device DAX and System RAM Mode](../README.md#converting-between-device-dax-and-system-ram-modes).

When the device is in System RAM mode, you can run the `mlc` program to test bandwidth and latency:

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

## MXCLI

`mxcli`, included in the root directory of this repository, is a management and support tool for sending CXL mailbox commands to a CXL memory device.
`mxcli` can be used to retrieve information about a CXL memory device such as identity and health information, read logs, issue resets, and perform other support actions.
It also has options to access standard PCIe capability and extended capability registers along with non-standard CXL specific DVSEC and DOE capability control registers, making it useful for debug and diagnostics.

```text
[root@hostname ~]# ./mxcli -d /dev/cxl/mem0 -cmd identify
Opening Device: /dev/cxl/mem0
2022-10-14 15:44:25.950 | INFO     | mxlib.mxlibpy.cmds.mailbox.mbox:send_command:158 - Mailbox cmd=0 - ret_code=0
{
    "fw_revision": "01.000.008.00",
    "total_capacity": 512,
    "volatile_capacity": 512,
    "persistent_capacity": 0,
    "partition_align": 0,
    "info_event_log_size": 16,
    "warning_event_log_size": 16,
    "failure_event_log_size": 16,
    "fatal_event_log_size": 16,
    "lsa_size": 0,
    "poison_list_max_mer": 0,
    "inject_poison_limit": 0,
    "poison_caps": 0,
    "qos_telemetry_caps": 0
}
```

`mxcli` also has an interactive mode with indexed menus, auto-discovery of CXL devices and auto-completion of commands/fields, making it a self-documenting and intuitive tool.
