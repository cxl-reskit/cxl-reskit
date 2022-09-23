# cxl-reskit/tools

Once you have run the top level bootstrap script, this subdirectory will contain essential CXL-related tools.

## ndctl

The ndctl package originally contained only tools for administering NVDIMMs and other non-volatile memory.
Those tools are now becoming generalized for non-volatile CXL memory.

But the ndctl repo also contains tools for administering volatile CXL memory, including daxctl and cxl_cli.

## MLC

One valuable tool that is not embedded within this Resource Kit is the mlc program from Intel. It is not
open source, but can be freely downloaded from intel from [this web site](https://www.intel.com/content/www/us/en/developer/articles/tool/intelr-memory-latency-checker.html).

You will need to download this tool in order to run the examples that use mlc.

## Usage Examples


* Convert special purpose memory to "online" memory
* Attempt to convert "online" memory to special purpose
* come up with some cxl_cli examples


