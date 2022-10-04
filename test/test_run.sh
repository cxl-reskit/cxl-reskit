#!/bin/bash

(( refresh_functions_file = 0 ))
(( unit_test_count = 0 ))
for unit_test in ./ut_*.sh ; do
    (( unit_test_count = unit_test_count + 1 ))
    if [[ ../cxlstat -nt ${unit_test} ]] ; then
        (( refresh_functions_file = 1 ))
    fi
done

if [[ ! -f functions.sh ]] ; then
    echo "Createing extracted function file"
    ./test_init.sh
fi

if (( refresh_functions_file == 1 )) ; then
    echo "Updating extracted function file"
    ./test_init.sh
fi

distro_name=$(cat /etc/os-release | grep "^ID=" | cut -d = -f 2)

(( iteration = 1 ))
for unit_test in ./ut_*.sh ; do
    if [[ (${unit_test} =~ fedora) && (${distro_name} != fedora) ]] ; then
        echo "# Test executing on non-Fedora system, skipping ${unit_test}"
        continue
    fi
    if [[ (${unit_test} =~ ubuntu) && (${distro_name} != ubuntu) ]] ; then
        echo "# Test executing on non-Ubuntu system, skipping ${unit_test}"
        continue
    fi
    echo "# Running test ${iteration} of ${unit_test_count} - ${unit_test}"
    echo "1..$(grep -c declare_ut ${unit_test})"
    ${unit_test}
done
