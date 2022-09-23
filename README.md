# cxl-reskit
The repository contains the Micron CXL Resource Kit - a collection of both documentation (how does CXL memory
really work in a system) and tools (benchmarks, administrative and diagnostic tools) to make it easy to get
started with CXL memory.

Rather than flattening the code from external repositories, we have sourced external repositories containing 
various tools. This makes it easy to see what was modified, while still supporting easy use of the external
tools.

This code and documentation covers Linux usage and testing. Other operating systems are outside the initial
scope.

## Getting Started

Run the bootstrap.sh script to fetch the external content:

```
  ./bootstrap.sh
```

## Examining Configured CXL Memory

The cxlstat tool is intended to tell you everything you might need to know about a system configured with
CXL memory:
* Is there any CXL memory configured in your system?
* Is your CXL memory configured as general- or special-purpose memory?
* How can you run programs and benchmarks using your CXL memory?
* Does your kernel contain CXL support, and is it enabled?

## About Kernel Support for CXL Memory
CXL memory may be the first "device" that many people encounter which does not require a driver to work.
CXL memory (in the 1.1/2.0 time frame) is mapped by bios, and described to the operating system via ACPI tables.
Even a kernel without CXL drivers can use CXL memory - once the memory is setup by bios, the CPU knows how to
access the memory when host physical addresses (HPAs) that map to the CXL memory are accessed.

Why do you need a driver? In a production environment you need it for certain administrative tasks
(such as updating firmware), and to retrieve log entries and inject them into the kernel event management 
subsystem. (check naming there)

## Linux: Special Purpose vs. General Purpose Memory

The CXL consortium has counseled system firmware/bios developers to configure CXL memory as the EFI_CONVENTIONAL_MEMORY
type with the EFI_MEMORY_SP attribute. By default, if your kernel is new enough (>= 5.12 CHECK THIS) your CXL memory will
appear as a DAX device (e.g. /dev/dax0.0). In that configuration, apps can map and use the memory via mmap from the DAX
device, or by using more advanced DAX-related tools.

If your bios did not apply the EFI_MEMORY_SP attribute, or if your kernel is too old, your CXL memory will appear as 
general purpose memory in a new NUMA node which has no local CPU cores associated with it. More on all of this later (hyperlink).

## Checking Your Configuration

The cxlstat tool (in the root directory of this repository) will tell you much of what you need to know about
your CXL configuration.  More detailed documentation can be found here (hyperlink), or by running cxlstt with the
--help option.

```
./cxlstat
(paste in output, and update as it improves)
```

The cxlstat tool is intended both as a useful way of checking your configuration, and as an example of how to 
do so in your own scripts or programs.

## Testing CXL Memory

The benchmarks (hyperlink) subdirectory contains several tools for running microbenchmark workloads against
CXL memory. Usage documentation for the various benchmarks is there.

## Configuring CXL Memory

The tools (hyperlink - not there yet) subdirectory contains tools that you may need for configuration tasks.
For example, you will likely need to build and install the latest version of ndctl, because it contains
the daxctl and cxl_cli tools - and packaged versions of ndctl are not new enough to contain sufficient 
CXL-related functionality.

## Running Apps in CXL Memory

If your CXL memory is configured as Special Purpose memory, only apps that can map memory via DAX or DAXfs
can use the memory. This has advantages, because the memory will not be used inadvertantly for apps that don't
expect it, but it does require apps that know how to map DAX memory.  The bencharks (hyperlink) contained in this repository
are modified to be able to test both CXL memory via DAX and conventional memory. (in a later version, talk about linkage tricks
and other allocators: convert this to a jira ticket and drop this parenthetical...).

If your CXL memory is configured as general purpose memory (i.e. you have a NUMA node for your CXL memory), you
can use the numactl tool to run your app while constraining the memory usage to the CXL NUMA node (or any other
NUMA node, for that matter).

```
numactl --membind 2 <my app command line>
```

More extensive documentation is available in the tools (hyperlink) subdirectory.

