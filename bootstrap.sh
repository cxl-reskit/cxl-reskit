#!/bin/bash

# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2022 Micron Technology, Inc.

#
# Clone the benchmark repos
#
mkdir -p benchmarks
cd ./benchmarks
if [ ! -d "mlc" ]; then
	echo -e "\nGetting benchmarks/mlc\n"
	if ! command -v wget --version &> /dev/null
	then
	    echo "Wget is not installed (or not in the PATH)"
	    echo "Please install wget and retry"
	    exit
	fi
	wget https://downloadmirror.intel.com/736634/mlc_v3.9a.tgz
	mkdir -p mlc
	tar -xzf mlc_v3.9a.tgz -C mlc
	rm mlc_v3.9a.tgz
else
	echo -e "\nAlready present: benchmarks/mlc\n"
fi
if ! command -v git --version &> /dev/null
then
    echo "Git is not installed (or not in the PATH)"
    echo "Please install git and retry"
    exit
fi
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
