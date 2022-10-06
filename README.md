# cxl-reskit

This is the top-level repository of the Micron CXL Memory Resource Kit (CMRK) - a collection of both documentation (how does CXL memory
really work in a system) and tools (benchmarks, administrative and diagnostic tools) to make it easy to get
started with CXL memory.

The CMRK comprises both original content and enhancements to external repositories.  We expect to grow the CMRK over time,
in collaboration with the community, to help create a vibrant ecosystem for getting the most out of CXL memory.

Rather than flattening the code from external repositories, we have sourced external repositories containing
various tools. This makes it easy to see what was modified, while still supporting easy use of the external
tools.  It also allows us to propose patches to upstream maintainers.

This code and documentation covers Linux usage and testing. Other operating systems are outside the current
scope.

## Recommended System Requirements

We strongly recommend the following to get the most out of this Resource Kit:

- The latest release of Fedora or Ubuntu LTS
  - Currently: Fedora 36 or Ubuntu 22.04.1 LTS
- The latest Linux kernel package for your distro
  - Upgrade on Fedora: `dnf update kernel kernel-devel kernel-headers`
  - Upgrade on Ubuntu: `apt upgrade linux-base`
- The `numactl` package installed on your system
- A system BIOS supporting the `EFI_MEMORY_SP` attribute (see: [About kernel support for CXL memory](#about-kernel-support-for-cxl-memory))
- One or more memory devices supporting CXL 2.0

Going forward in this documentation, "CXL" refers to version 2.0 of the protocol unless otherwise specified.

## Minimum System Requirements

- A 5.12 Linux kernel or higher is required to detect CXL memory devices.
- A 5.18 Linux kernel or higher is required to perform certain configuration and management commands via the CXL mailbox interface.
- If your distro does not provide a 5.18 kernel or higher, please build and install the *stable* kernel (5.19 as of this writing) from
[kernel.org](https://kernel.org/). Follow the documentation that your distro provides, or this
[how-to](https://kernelnewbies.org/KernelBuild) which should work on most Linux systems.

## Getting Started

Clone this repository and run the bootstrap.sh script to fetch the external content:

```shell
  ./bootstrap.sh
```

TODO: add a bulleted TOC list with links directly to topics of interest

## Quick Links

- [Checking Your CXL Configuration](#examining-configured-cxl-memory)

## About Kernel Support for CXL Memory

CXL memory may be the first "device" that many people encounter which does not require a driver to function.

CXL memory (in the 1.1/2.0 time frame) is mapped by BIOS (implementing UEFI), and described to the operating system via ACPI tables.
Even a kernel without CXL drivers can use CXL memory - once the memory is setup by BIOS, the CPU knows how to
access the memory when host physical addresses (HPAs) that map to the CXL memory are accessed.

Why do you need a driver? In a production environment you need it for certain administrative tasks
(such as updating firmware), and to retrieve log entries and inject them into the kernel event management
subsystem. TODO: check naming there.

## Special Purpose vs. General Purpose Memory

The CXL consortium has counseled system BIOS and firmware developers to configure CXL memory as the `EFI_CONVENTIONAL_MEMORY`
type with the `EFI_MEMORY_SP` attribute.

As long as this configuration is in place, and your kernel is new enough (>= 5.12), your CXL memory will
appear as a DAX device (e.g. `/dev/dax0.0`). In that configuration, apps can map and use the memory via mmap from the DAX
device, or by using more advanced DAX-related tools.

If your BIOS did not apply the `EFI_MEMORY_SP` attribute, or if your kernel is too old, your CXL memory will appear as
general purpose memory in a new NUMA node which has no local CPU cores associated with it. More on all of this later (TODO hyperlink).

## Examining Configured CXL Memory

The `cxlstat` tool in the root directory of this repository is intended to tell you everything you might need to know about a
system configured with CXL memory, for example:

- Is there any CXL memory configured in your system?
- Is your CXL memory configured as general or special purpose memory?
- How can you run programs and benchmarks using your CXL memory?
- Does your kernel contain CXL support, and is it enabled?

More detailed documentation can be found here (TODO hyperlink), or by running cxlstat with the `--help` option.

```shell
./cxlstat
(TODO paste in output, and update as it improves)
```

The `cxlstat` tool is intended both as a useful way of checking your configuration, and as an example of how to
do so in your own scripts or programs.

## Testing CXL Memory

The [benchmarks](benchmarks) subdirectory contains several tools for running microbenchmark workloads against
CXL memory. Usage documentation for the various benchmarks is there.

## Configuring CXL Memory

The [tools](tools) subdirectory contains tools that you may need for configuration tasks.

For example, you will likely need to build and install the latest version of [ndctl](tools/README.md#ndctl), because it contains
the `daxctl` tool - and packaged versions of `daxctl` are not new enough to contain sufficient
CXL-related functionality.

## Running Apps in CXL Memory

If your CXL memory is configured as [special purpose memory](#special-purpose-vs-general-purpose-memory), only apps that can map memory via `devdax` or `fsdax` mode
can use the memory. This has advantages, because the memory will not be used inadvertently for apps that don't
expect it, but it does require apps that know how to map DAX memory.

The [benchmarks](benchmarks) contained in this repository
are modified to be able to test both CXL memory via DAX and conventional memory. (TODO in a later version, talk about linkage tricks
and other allocators: convert this to a jira ticket and drop this parenthetical...).

If your CXL memory is configured as general purpose memory (i.e. you have a NUMA node for your CXL memory), you
can use the numactl tool to run your app while constraining the memory usage to the CXL NUMA node (or any other
NUMA node, for that matter).

```shell
numactl --membind 2 <my app command line>
```

More extensive documentation is available in the [tools](tools) subdirectory.
