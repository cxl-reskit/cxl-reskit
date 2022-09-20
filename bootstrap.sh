#!/bin/bash


#
# Clone the benchmark repos
#
mkdir -p benchmarks
cd ./benchmarks
git clone https://github.com/jagalactic/multichase.git
git clone https://github.com/jagalactic/STREAM.git

# note this one is local, not github yet
git clone ssh://git@bitbucket.micron.com/sbusw/cxl-stressapptest.git

wget https://www.intel.com/content/www/us/en/download/736633/736634/intel-memory-latency-checker-intel-mlc.html

