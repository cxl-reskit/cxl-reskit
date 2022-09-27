# cxl-reskit/benchmarks

This subdirectory contains (micro)benchmarks that have been modified to make it easy to test
CXL memory.

## Compiling the Benchmarks

You can compile all the tools and benchmarks by running the top-level bootscript.sh script as follows:

```shell
./bootstrap.sh --build
```

Or you can build the benchmarks by following the in-tree documentation in the subdirectories here 
(e.g., multichase, STREAM, stressapptest). Note that it might be necessary to install compilers and 
development tools to complete those builds.

## Testing CXL memory via DAX

Check whether your memory is configured as special purpose memory:

```shell
# grep dax /proc/iomem
      1080000000-187fffffff : dax0.0
      1880000000-207fffffff : dax1.0
```

If your memory is configured as a DAX device, you can use the benchmarks to test the DAX memory.
In these configurations, the "memory under test" is the CXL memory, but the benchmark code is running
from conventional memory.

## Multichase

Multichase is a graph analysis / pointer chasing benchmark. [Documentation can be found here.](https://github.com/jagalactic/multichase).

TODO: link multichase from cxl-reskit org.

Run multichase against standard memory:

```shell
# ./multichase 
cheap_create_dax: /dev/dax0.0 size is 34359738368
Allocated cursor_heap size 34359738368
87.869
```

TODO: figure out and explain what the output/result means from Multichase

Run multichase against a DAX device:

```shell

# ./multichase -d /dev/dax0.0
cheap_create_dax: /dev/dax0.0 size is 34359738368
Allocated cursor_heap size 34359738368
92.268
```

TODO: Substitute results from a faster CXL device.

When running multichase with the "-d <daxdev>" argument, the memory-under-test is allocated from the DAX device, but all other memory used by the benchmark (code, stacks, local data) is allocated from regular DRAM. 

## STREAM

Stream is a benchmark for measuring sustained memory bandwidth. [Documentation can be found here.](https://github.com/jagalactic/STREAM)

TODO: link STREAM from cxl-reskit org.

Run Stream against regular DRAM in a system:

```shell
# ./stream_mu -a 1000000000
arraycount: 1000000000
a: 0x7fefbca00000
b: 0x7ff199765000
c: 0x7ff3764ca000
-------------------------------------------------------------
STREAM version $Revision: 5.10 $
-------------------------------------------------------------
This system uses 8 bytes per array element.
-------------------------------------------------------------
Array size = 1000000000 (elements), Offset = 0 (elements)
Memory per array = 7629.4 MiB (= 7.5 GiB).
Total memory required = 22888.2 MiB (= 22.4 GiB).
Each kernel will be executed 10 times.
 The *best* time for each kernel (excluding the first iteration)
 will be used to compute the reported bandwidth.
-------------------------------------------------------------
Number of Threads requested = 208
Number of Threads counted = 208
-------------------------------------------------------------
Your clock granularity/precision appears to be 1 microseconds.
Each test below will take on the order of 267582 microseconds.
   (= 267582 clock ticks)
Increase the size of the arrays if this shows that
you are not getting at least 20 clock ticks per test.
-------------------------------------------------------------
WARNING -- The above is only a rough guideline.
For best results, please be sure you know the
precision of your system timer.
-------------------------------------------------------------
Function    Best Rate MB/s  Avg time     Min time     Max time
Copy:           58345.2     0.278284     0.274230     0.287886
Scale:          58091.0     0.279548     0.275430     0.288173
Add:            58753.4     0.413312     0.408487     0.423039
Triad:          58794.4     0.413108     0.408202     0.427315
-------------------------------------------------------------
Solution Validates: avg error less than 1.000000e-13 on all three arrays
-------------------------------------------------------------
```

Run Stream against CXL memory in a system:

```
# ./stream_mu -a 1000000000 --memdev /dev/dax0.0
arraycount: 1000000000
memdev: /dev/dax0.0
a: 0x7f4f51600000 phys: (nil)
b: 0x7f512e365000 phys: 0x1dcd65000
c: 0x7f530b0ca000 phys: 0x3b9aca000
-------------------------------------------------------------
STREAM version $Revision: 5.10 $
-------------------------------------------------------------
This system uses 8 bytes per array element.
-------------------------------------------------------------
Array size = 1000000000 (elements), Offset = 0 (elements)
Memory per array = 7629.4 MiB (= 7.5 GiB).
Total memory required = 22888.2 MiB (= 22.4 GiB).
Each kernel will be executed 10 times.
 The *best* time for each kernel (excluding the first iteration)
 will be used to compute the reported bandwidth.
-------------------------------------------------------------
Number of Threads requested = 208
Number of Threads counted = 208
-------------------------------------------------------------
Your clock granularity/precision appears to be 1 microseconds.
Each test below will take on the order of 2767761 microseconds.
   (= 2767761 clock ticks)
Increase the size of the arrays if this shows that
you are not getting at least 20 clock ticks per test.
-------------------------------------------------------------
WARNING -- The above is only a rough guideline.
For best results, please be sure you know the
precision of your system timer.
-------------------------------------------------------------
Function    Best Rate MB/s  Avg time     Min time     Max time
Copy:            4219.7     3.796197     3.791722     3.800682
Scale:           4219.5     3.797511     3.791948     3.805695
Add:             4465.4     5.377409     5.374637     5.379143
Triad:           4465.1     5.378502     5.375028     5.383458
-------------------------------------------------------------
Solution Validates: avg error less than 1.000000e-13 on all three arrays
-------------------------------------------------------------
```

When running stream_mu with the "--memdev <daxdev>" argument, the memory-under-test is allocated from the DAX device, but all other memory used by the benchmark (code, stacks, local data) is allocated from regular DRAM. 
      
TODO: substitute results from a faster CXL device.

## Stressapptest

TODO: (Jacob) Usage example, comparing a run in regular memory with a run in CXL memory

## Testing CXL memory via NUMA
      
The examples above work when your CXL memory is configured as special purpose (AKA soft reserved) memory - which is mappable via DAX. It is also possible to use CXL memory when it is "online" as a NUMA node. (TODO: link to conversion example in tools)


TODO: Usage examples, showing the following:
* Use numactl to run each benchmark in the normal and cxl numa nodes

