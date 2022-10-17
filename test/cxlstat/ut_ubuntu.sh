#!/bin/bash

source test_utils.sh
source functions.sh

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

# NOTE - The package ndctl has to be installed for this test to work

deb_package_check ndctl is_installed major_ver minor_ver upgradable
declare_ut
assert_equal ${is_installed} 1

version=72
declare_ut
assert_equal ${major_ver} ${version} 

declare_ut
assert_equal ${minor_ver} 1

declare_ut
assert_equal ${upgradable} 0
