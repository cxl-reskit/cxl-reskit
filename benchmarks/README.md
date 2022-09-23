# cxl-reskit/benchmarks

This subdirectory contains (micro)benchmarks that have been modified to make it easy to test
CXL memory.

## Compiling the Benchmarks

You can compile all the tools and benchmarks by running the top-level bootscript.sh script as follows:

```
./bootstrap.sh --build
```

Or you can build the benchmarks by following the in-tree documentation in the subdirectories here 
(multichase, STREAM, stressapptest). Note that it might be necessary to install compilers and 
development tools to complete those builds.

## Testing CXL memory via DAX

Check whether your memory is configured as special purpose memory:

```
$ cxlstat --dax

/dev/dax0.0
```

If your memory is configured as a DAX device, you can use the benchmarks to test the DAX memory.
In these configurations, the "memory under test" is the CXL memory, but the benchmark code is running
from conventional memory.

## Multichase

Usage example, comparing a run in regular memory with a run in CXL memory

## STREAM

Usage example, comparing a run in regular memory with a run in CXL memory

## Stressapptest

Usage example, comparing a run in regular memory with a run in CXL memory

## Testing CXL memory via NUMA

Usage examples, showing the following:
* convert SPM to a numa node with daxctl
* Use numactl to run each benchmark in the cxl numa node

