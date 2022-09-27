#!/bin/bash


#
# Clone the benchmark repos
#
mkdir -p benchmarks
cd ./benchmarks
git clone https://github.com/jagalactic/multichase.git
git clone https://github.com/jagalactic/STREAM.git
git clone https://github.com/cxl-reskit/stressapptest.git
wget https://downloadmirror.intel.com/736634/mlc_v3.9a.tgz
mkdir mlc
tar -xzf mlc_v3.9a.tgz -C mlc
rm mlc_v3.9a.tgz

#
# Clone the tools
#
cd -
cd ./tools
git clone https://github.com/pmem/ndctl.git
