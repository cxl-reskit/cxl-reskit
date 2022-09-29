#!/bin/bash


#
# Clone the benchmark repos
#
mkdir -p benchmarks
cd ./benchmarks
if [ ! -d "multichase" ]; then
	echo -e "\nCloning benchmarks/multichase\n"
	git clone https://github.com/cxl-reskit/multichase.git
else
	echo -e "\nAlready present: benchmarks/multichase\n"
fi
if [ ! -d "STREAM" ]; then
	echo -e "\nCloning benchmarks/STREAM\n"
	git clone https://github.com/cxl-reskit/STREAM.git
else
	echo -e "\nAlready present: benchmarks/STREAM\n"
fi
if [ ! -d "stressapptest" ]; then
	echo -e "\nCloning benchmarks/stressapptest\n"
	git clone https://github.com/cxl-reskit/stressapptest.git
else
	echo -e "\nAlready present: benchmarks/stressapptest\n"
fi
if [ ! -d "mlc" ]; then
	echo -e "\nGetting benchmarks/mlc\n"
	wget https://downloadmirror.intel.com/736634/mlc_v3.9a.tgz
	mkdir -p mlc
	tar -xzf mlc_v3.9a.tgz -C mlc
	rm mlc_v3.9a.tgz
else
	echo -e "\nAlready present: benchmarks/mlc\n"
fi

#
# Clone the tools
#
cd -
cd ./tools
if [ ! -d "ndctl" ]; then
	echo -e "\nCloning tools/ndctl\n"
	git clone https://github.com/pmem/ndctl.git
else
	echo -e "\nAlready present: tools/ndctl\n"
fi

