# CXL Memory Resource Kit (CMRK)

This is the top-level repository of the CXL Memory Resource Kit (CMRK) which is a collection of
documentation, tools, and benchmarks for use with CXL memory.

The CMRK comprises both original content and CXL-related enhancements to external projects
that we plan to submit to upstream where appropriate.
Our goal is to expand the CMRK over time, in collaboration with the community,
to help enable applications to take full advantage of CXL memory.

When making CXL-related enhancements to external projects, we source those repositories rather
than flattening the code.
This makes it easy to see what we modified, and also simplifies the process of submitting
patches to upstream maintainers.

The CMRK documentation and code is currently focused on Linux only.

## Recommended System Requirements

We recommend the following system configuration to use CXL memory:

- A CPU and system BIOS that supports CXL memory
- The latest release of Fedora or Ubuntu LTS
  - Currently: Fedora 36 or Ubuntu 22.04.1 LTS
- The latest Linux kernel package available for the distro
  - Upgrade on Fedora: `dnf update kernel`
  - Upgrade on Ubuntu: `apt upgrade linux-base`
- The `daxctl` package installed on your system (version 72 or later)
- The `numactl` package installed on your system

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
- [About NDCTL and DAXCTL](#about-ndctl-and-daxctl)
- [Using CXL Memory as a DAX Device](#using-cxl-memory-as-a-dax-device)
- [Using CXL Memory as System RAM](#using-cxl-memory-as-system-ram)
- [Converting Between Device DAX and System RAM Modes](#converting-between-device-dax-and-system-ram-modes)
- [Testing CXL Memory](#testing-cxl-memory)
- [About MXCLI](#about-mxcli)

## Examining Your CXL Memory

The `cxlstat` tool in the root directory of this repository is intended to tell you everything you
might need to know about a system configured with CXL memory, for example:

- Does your kernel contain support for CXL?
- Are there CXL memory devices present in your system?
- How is your CXL memory currently configured?

```shell
./cxlstat
```

```text
$ sudo ./cxlstat
System booted using UEFI
Detected Ubuntu
Minimum kernel version requirement met - 5.19.0-21-generic vs. 5.15
Kernel boot configuration located (/boot/config-5.19.0-21-generic)

The package daxctl is installed and at a sufficient version (found 74.0)

Detecting CXL devices ...
            CXL Device : mem0
                Vendor : Micron Technology Inc
             Device ID : Device 6400
               Address : 0000:7f:00.0
                  Size : 128 GB
       Mailbox Present : yes

Detecting DAX devices ...
                  Name : dax0.0
                  Path : /dev/dax0.0
                  Size : 128 GB
          Memory Range : 0x1050000000-0x304FFFFFFF (128 GB)
                  Mode : devdax (memory directly usable only via DAX access)

The daxctl command appears usable for all normal functions.

Standard CXL mailbox commands may be used (no vendor-specific commands allowed).
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
However, unsupported commands may be required to use vendor specific features or perform maintenance operations such as firmware
upgrade on the memory device.

A kernel built with the `CXL_MEM_RAW_COMMANDS` option allows allows vendor-specific CXL mailbox commands
(i.e., "raw commands") to be sent to the device. This is disabled by default, but the option exists
so that you can enable it in a custom kernel build.

`cxlstat` checks your kernel config file (`` /boot/config-`uname -r` ``) to report whether the
`CXL_MEM_RAW_COMMANDS` option is enabled or not.

## About BIOS Support for Specific Purpose Memory

The CXL consortium has counseled system BIOS and firmware developers to configure CXL memory as the
`EFI_CONVENTIONAL_MEMORY` type with the `EFI_MEMORY_SP` attribute.

Linux configures CXL memory during boot as follows.

- If your BIOS has applied the `EFI_MEMORY_SP` attribute:
  - Your CXL memory will appear as a DAX device (e.g. `/dev/dax0.0`).
  - Your CXL memory can be used only by applications that call `mmap` to memory-map the
device. See [Using CXL Memory as a DAX Device](#using-cxl-memory-as-a-dax-device).
- If your BIOS did **not** apply the `EFI_MEMORY_SP` attribute:
  - Your CXL memory will appear in one or more new NUMA nodes which have no local CPU cores.
  - You can use the `numactl` tool to set the memory placement policy for any application that
  needs to use the CXL memory.
  See [Using CXL Memory as System RAM](#using-cxl-memory-as-system-ram).

It may be possible to convert the mode that the CXL memory is in after the system has already booted.
See [Converting Between Device DAX and System RAM Modes](#converting-between-device-dax-and-system-ram-modes).

## Enabling Specific Purpose Memory

On Intel systems that support the `EFI_MEMORY_SP` attribute, it is always enabled. No action is needed.

On an AMD system, you may need to enable it in the BIOS configuration:

- Advanced &rarr; AMD CBS &rarr; CXL Common Options &rarr; CXL SPM &rarr; set to "Enabled"

## About NDCTL and DAXCTL

The [ndctl](https://github.com/pmem/ndctl/) project originally contained only tools for
administering NVDIMMs and other non-volatile memory. These tools are now being generalized to also
support CXL memory devices. One of these tools is `daxctl`, which now serves as the primary tool
for configuring CXL memory.

`cxlstat` checks whether the `daxctl` package is installed, and that the installed version is new
enough to support CXL memory.

See the [NDCTL User Guide](https://docs.pmem.io/ndctl-user-guide/installing-ndctl)
for more information on installing `daxctl`.
Note that on the [recommended distros](#recommended-system-requirements), installing from packages
is sufficient. Older distros may require building and installing `ndctl` or its sub-packages (`daxctl`, the `cxl` CLI) from source to get a new enough version.

## Using CXL Memory as a DAX Device

When CXL memory is in device DAX mode, it is only usable  by applications that can map memory from
the DAX device.

Applications that use `mmap` on CXL memory must do the following:

- Open the DAX device (e.g. `/dev/dax0.0`)
- Specify a length and offset with a 2 MiB alignment

The following is an example of a minimal C program that writes to CXL memory via `mmap`.

```c
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

int main()
{
  /* DAX mapping requires a 2MiB alignment */
  size_t page_size = 2 * 1024 * 1024;

  int fd = open("/dev/dax0.0", O_RDWR);
  if (fd == -1) {
    perror("open() failed");
    return 1;
  }

  void *dax_addr = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if (dax_addr == MAP_FAILED) {
    perror("mmap() failed");
    close(fd);
    return 1;
  }

  /* Write something to the memory */
  strcpy(dax_addr, "hello world");

  munmap(dax_addr, page_size);
  close(fd);
  return 0;
}
```

More examples can be found in the patches applied in the `cxl` branch of these benchmark repositories:

- [multichase](https://github.com/cxl-reskit/multichase/commits/cxl)
- [STREAM](https://github.com/cxl-reskit/STREAM/commits/cxl)
- [stressapptest](https://github.com/cxl-reskit/stressapptest/commits/cxl)

## Using CXL Memory as System RAM

When CXL memory is in system RAM mode, Linux maps it to one or more NUMA nodes that can be used by any application.

You can run `numactl -H` to view the NUMA nodes on your system. In this example, NUMA node 1 (which has no local CPUs) corresponds to
the CXL memory device.

```text
$ numactl -H
available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3 4 5 6 7
node 0 size: 63696 MB
node 0 free: 60568 MB
node 1 cpus:
node 1 size: 128505 MB
node 1 free: 127588 MB
node distances:
node   0   1
  0:  10  50
  1:  255  10
```

You can use `numactl` with the `--membind` option to run your app while constraining its memory allocations to a CXL NUMA node.
In this example, the CXL memory is on NUMA node 1.

```shell
numactl --membind 1 <my app command line>
```

## Converting Between Device DAX and System RAM Modes

Depending on the BIOS configuration, Linux will bring up CXL memory devices in either device DAX
mode or system RAM mode. See
[About BIOS Support for Specific Purpose Memory](#about-bios-support-for-specific-purpose-memory).

Use `daxctl list` to list the current state of CXL memory devices on the system.
If the output of `daxctl list` is empty, it may be necessary to reboot the system and
[configure the BIOS](#enabling-specific-purpose-memory) to enable specific purpose memory.

To convert from device DAX mode to system RAM mode:

```shell
sudo daxctl reconfigure-device --mode=system-ram dax0.0 --force
```

`daxctl` also provides a command to convert from system RAM mode to Device DAX mode. However, this
is not guaranteed to succeed, depending on the state of the system.

```shell
sudo daxctl reconfigure-device --mode=devdax dax0.0 --force
```

If `daxctl reconfigure-device --mode=devdax` does not succeed, a reboot may be needed to get the
CXL memory device back into device DAX mode.

More extensive documentation for `daxctl` is available in the
[NDCTL User Guide](https://docs.pmem.io/ndctl-user-guide/).

## Testing CXL Memory

After you run the [bootstrap script](#getting-started), the [benchmarks](benchmarks) subdirectory
will contain several benchmark tools for testing CXL memory:

- [Intel Memory Latency Checker (MLC)](https://www.intel.com/content/www/us/en/developer/articles/tool/intelr-memory-latency-checker.html)
- [multichase](https://github.com/cxl-reskit/multichase)
- [STREAM](https://github.com/cxl-reskit/STREAM)
- [stressapptest](https://github.com/cxl-reskit/stressapptest)

The tools that are open source (multichase, STREAM, stressapptest) have been modified to be able to test
CXL memory in [device DAX](#using-cxl-memory-as-a-dax-device) as well as
[system RAM](#using-cxl-memory-as-system-ram) modes.

Usage documentation for all the benchmark tools is in [benchmarks/README.md](benchmarks/README.md).

## About MXCLI

`mxcli`, included in the base directory of this repository, is a management and support tool for
sending CXL mailbox commands to a CXL memory device. `mxcli` can be used to retrieve identity
and health information about a CXL device, read logs, issue resets, and
perform other support actions. It also has options to access standard PCIe capability and extended
capability registers along with non-standard CXL specific DVSEC and DOE capability control
registers, making it useful for debug and diagnostics.

To see the full command line help, use the `./mxcli --help` command.
If you run `mxcli` with an unqualified command line, it will provide a menu interface.

The following example issues an IDENTIFY mailbox command to a CXL memory device.

```text
$ sudo ./mxcli -d /dev/cxl/mem0 -cmd identify
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

`mxcli` also has an interactive mode with indexed menus, auto-discovery of CXL devices and
auto-completion of commands/fields, making it a self-documenting and intuitive tool.
