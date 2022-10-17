# cxl-reskit

This is the top-level repository of the CXL Memory Resource Kit (CMRK) - a collection of
documentation, tools, and benchmarks for use with CXL memory.

The CMRK comprises both original content and CXL-related enhancements to external projects
that we plan to propose for inclusion in upstream where appropriate.
We expect to continue adding to the CMRK over time, in collaboration with the community,
to help create a vibrant software ecosystem for getting the most out of CXL memory.

When making CXL-related enhancements to external projects, we source those repositories rather
than flattening the code.
This makes it easy to see what was modified, while still supporting ease of use.
It also allows us to propose patches to upstream maintainers.

The CMRK documentation and code is currently focused on Linux only.


## Recommended System Requirements

We recommend the following system configuration to use CXL memory:

- The latest release of Fedora or Ubuntu LTS
  - Currently: Fedora 36 or Ubuntu 22.04.1 LTS
- The latest Linux kernel package available for the distro
  - Upgrade on Fedora: `dnf update kernel`
  - Upgrade on Ubuntu: `apt upgrade linux-base`
- The `daxctl` package installed on your system (version 72 or later)
- The `numactl` package installed on your system
- A system BIOS supporting the `EFI_MEMORY_SP` attribute (see: [About kernel support for CXL memory](#about-kernel-support-for-cxl-memory))

## Getting Started

Clone this repository and run the bootstrap.sh script to fetch the external content:

```shell
./bootstrap.sh
```

## Quick Links

- [Examining Your CXL Memory](#examining-your-cxl-memory)
- [About Kernel Support for CXL Memory](#about-kernel-support-for-cxl-memory)
- [About Raw Command Support](#about-raw-command-support)
- [About BIOS Support for Specific Purpose Memory](#about-bios-support-for-specific-purpose-memory)
- [Enabling Specific Purpose Memory](#enabling-specific-purpose-memory)
- [Using CXL Memory as a DAX Device](#using-cxl-memory-as-a-dax-device)
- [Using CXL Memory as System RAM](#using-cxl-memory-as-system-ram)
- [Converting Between Device DAX and System RAM Modes](#converting-between-device-dax-and-system-ram-modes)
- [Testing CXL Memory](#testing-cxl-memory)
- [Configuring CXL Memory](#configuring-cxl-memory)

## Examining Your CXL Memory

The `cxlstat` tool in the root directory of this repository is intended to tell you everything you might need to know about a
system configured with CXL memory, for example:

- Is there any CXL memory configured in your system?
- Is your CXL memory configured as conventional or [specific purpose](#about-bios-support-for-specific-purpose-memory) memory?
- How can you run programs and benchmarks using your CXL memory?
- Does your kernel contain CXL support, and is it enabled?

```shell
./cxlstat
```

```text
root@hostname:~/cxl-reskit# ./cxlstat
System booted using UEFI
Detected Ubuntu
Minimum kernel version requirement met - 5.15.0-46-generic vs. 5.15
Kernel boot configuration located (/boot/config-5.15.0-46-generic)

The package daxctl is installed and at a sufficient version.
daxctl version: 74.0

Detecting CXL devices ...

Standard CXL mailbox commands may be used
```

The `cxlstat` tool is intended both as a useful way of checking your configuration, and as an example of how to
do so in your own scripts or programs.

## About Kernel Support for CXL Memory

Linux supports CXL memory starting with the 5.12 kernel, though it continues to receive
CXL-related updates with each release.

The kernels in the recommended distros are built with the required options to support CXL memory.
In particular, as of 5.12, the `CXL_CONFIG_BUS` and `CXL_CONFIG_MEM` options are required.

`cxlstat` checks your kernel config file (`` /boot/config-`uname -r` ``) to verify that your kernel
supports CXL memory.

## About Raw Command Support

Linux supports CXL mailbox commands defined in the CXL specification.
However, unsupported commands may be required to use vendor specific features or perform a firmware
upgrade on the device.

A kernel built with the `CXL_MEM_RAW_COMMANDS` option allows allows vendor-specific CXL mailbox commands
(i.e., "raw commands") to be sent to the device. This is disabled by default, but the option exists
so that you can enable it in a custom kernel build.

`cxlstat` checks your kernel config file (`` /boot/config-`uname -r` ``) to report whether the
`CXL_MEM_RAW_COMMANDS` option is enabled or not.

## About BIOS Support for Specific Purpose Memory

The CXL consortium has counseled system BIOS and firmware developers to configure CXL memory as the
`EFI_CONVENTIONAL_MEMORY` type with the `EFI_MEMORY_SP` attribute.

There are two possible outcomes when your system boots:

- If your BIOS has applied the `EFI_MEMORY_SP` attribute, your CXL memory will appear as a DAX
device (e.g. `/dev/dax0.0`), to be used exclusively by applications that have memory-mapped the
device. See [Using CXL Memory as a DAX Device](#using-cxl-memory-as-a-dax-device).
- If your BIOS did **not** apply the `EFI_MEMORY_SP` attribute, your CXL memory will appear as
conventional memory in a new NUMA node which has no local CPU cores associated with it. See
[Using CXL Memory as System RAM](#using-cxl-memory-as-system-ram).

It may be possible to convert the mode that the CXL memory is in after the system has already booted.
See [Converting Between Device DAX and System RAM Modes](#converting-between-device-dax-and-system-ram-modes).

## Enabling Specific Purpose Memory

On Intel systems that support the `EFI_MEMORY_SP` attribute, it is always enabled. No action is needed.

On an AMD system, you may need to enable it in the BIOS configuration.

> TODO: add the instructions for AMD

## Using CXL Memory as a DAX Device

When your CXL memory is configured as [specific purpose memory](#about-bios-support-for-specific-purpose-memory),
it can only be used by applications that have memory-mapped the DAX device.

> TODO: short mmap code example?
> TODO: stream command line?

## Using CXL Memory as System RAM

When your CXL memory is configured as conventional memory (i.e. you have a NUMA node for your CXL memory), you
can use the `numactl` tool to run your app while constraining its memory allocations to the CXL NUMA node.

```shell
numactl --membind 2 <my app command line>
```

## Converting Between Device DAX and System RAM Modes

More extensive documentation is available in the [tools](tools) subdirectory.

> TODO: fix

## Testing CXL Memory

The [benchmarks](benchmarks) subdirectory contains several tools for running microbenchmark workloads against
CXL memory. These have been modified to be able to test both [device DAX](#using-cxl-memory-as-a-dax-device)
and [system RAM](#using-cxl-memory-as-system-ram) modes.

Usage documentation is in [benchmarks/README.md](benchmarks/README.md).

## Configuring CXL Memory

The [tools](tools) subdirectory contains tools that you may need for configuration tasks, and some
examples of their usage.
