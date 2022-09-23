#!/bin/bash


#
# Clone the benchmark repos
#
mkdir -p benchmarks
cd ./benchmarks
git clone https://github.com/jagalactic/multichase.git
git clone https://github.com/jagalactic/STREAM.git
git clone https://github.com/cxl-reskit/stressapptest.git

#
# Clone the tools
#
cd -
cd ./tools
git clone https://github.com/pmem/ndctl.git

