#!/bin/bash

source test_utils.sh
source functions.sh

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

# NOTE - The package ndctl has to be installed for this test to work

declare_ut
assert_true "rpm_check_upgradable ndctl 60 1"

declare_ut
assert_false "rpm_check_upgradable ndctl 80 1"

# NOTE - The currently installed version of ndctl must be the latest available
#        for this test to work.
declare_ut
version=$(rpm -q --queryformat '%{VERSION}' ndctl)
assert_false "rpm_check_upgradable ndctl ${version} 0"

rpm_package_check ndctl is_installed major_ver minor_ver upgradable
declare_ut
assert_equal ${is_installed} 1

declare_ut
assert_equal ${major_ver} ${version} 

declare_ut
assert_equal ${minor_ver} 0

declare_ut
assert_equal ${upgradable} 0
