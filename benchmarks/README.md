# cxl-reskit/benchmarks

This subdirectory contains benchmarks that have been modified to make it easy to test
CXL memory.

## Compiling the Benchmarks

Build instructions are in the sections below for each benchmark.

Note that it might be necessary to install prerequisite packages such as compilers and development tools to complete these builds.

## Quick Links

- [Testing CXL Memory via DAX](#testing-cxl-memory-via-dax)
- [Testing CXL Memory via NUMA](#testing-cxl-memory-via-numa)
- [MLC](#mlc)
- [Multichase](#multichase)
- [STREAM](#stream)
- [Stressapptest](#stressapptest)

## Testing CXL memory via DAX

If your CXL memory is in [device DAX mode](../README.md#using-cxl-memory-as-a-dax-device),
you can test it by running benchmarks on the DAX device (e.g. `/dev/dax0.0`).

In this configuration, the "memory under test" is the CXL memory, but the benchmark code is running
from local DRAM.

If no DAX devices are visible, your memory may be "online" as a NUMA node.
In this case, you can still use the `numactl` program to run benchmarks on the CXL NUMA node.
See [Testing CXL memory via NUMA](#testing-cxl-memory-via-numa).

## Testing CXL memory via NUMA

If your CXL memory is in [system RAM mode](../README.md#using-cxl-memory-as-system-ram),
you can test it by using `numactl` to set the memory placement policy of the benchmark application.

See [Using CXL Memory as System RAM](../README.md#using-cxl-memory-as-system-ram) for an example
of locating which NUMA node your CXL memory resides on.

## MLC

The Memory Latency Checker (`mlc`) program from Intel is a valuable tool for understanding memory
performance. It is not open source, but can be freely downloaded from
[this website](https://www.intel.com/content/www/us/en/developer/articles/tool/intelr-memory-latency-checker.html).

`mlc` only tests system DRAM and CXL memory via NUMA. It cannot be used to test CXL memory that is
in device DAX mode.

```shell
cd mlc/Linux
sudo ./mlc --latency_matrix
sudo ./mlc --bandwidth_matrix
```

## Multichase

Multichase is a graph analysis / pointer chasing benchmark.
[Documentation can be found here.](https://github.com/cxl-reskit/multichase).

### Build multichase

Building `multichase` requires the `cmake` package and a C++ compiler (such as `g++`) installed on the system.

```shell
cd multichase
make all
```

### Run multichase against local DRAM

```shell
./multichase
```

### Run multichase against a DAX device

When running multichase with the `-d <daxdev>` argument, the memory-under-test is allocated from
the DAX device, but all other memory used by the benchmark (code, stacks, local data) is allocated
from system DRAM.

```shell
sudo ./multichase -d <dax-device>
```

### Run multichase against a NUMA node

```shell
numactl --membind <node> ./multichase
```

## STREAM

STREAM is a benchmark for measuring sustained memory bandwidth.
[Documentation can be found here.](https://github.com/cxl-reskit/STREAM)

### Build STREAM

Building `stream` requires a C compiler (such as `gcc`) installed on the system.

```shell
cd STREAM
make all
```

### Run STREAM against local DRAM

```shell
./stream -a 1000000000
```

### Run STREAM against a DAX device

When running `stream` with the `--memdev <daxdev>` argument, the memory-under-test is allocated
from the DAX device, but all other memory used by the benchmark (code, stacks, local data) is
allocated from system DRAM.

```shell
sudo ./stream -a 1000000000 --memdev <dax-device>
```

### Run STREAM against a NUMA node

```shell
numactl --membind <node> ./stream -a 1000000000
```

## Stressapptest

Stressful Application Test (`stressapptest`) is a memory load testing tool.
[Documentation can be found here.](https://github.com/cxl-reskit/stressapptest/)

### Build stressapptest

Building `stressapptest` requires a C++ compiler (such as `g++`) installed on the system.

```shell
cd stressapptest
./configure && make -j`nproc`
```

### Run stressapptest against local DRAM

```shell
src/stressapptest
```

### Run stressapptest against a DAX device

When running `stressapptest` with the `-D <daxdev>` argument, the memory-under-test is allocated
from the DAX device, but all other memory used by the benchmark (code, stacks, local data) is
allocated from system DRAM.

```shell
sudo src/stressapptest -D <dax-device>
```

### Run stressapptest against a NUMA node

```shell
numactl --membind <node> src/stressapptest
```
