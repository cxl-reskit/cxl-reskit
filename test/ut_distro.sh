#!/bin/bash

source test_utils.sh
source functions.sh

SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)

ROOT_PREFIX=${SCRIPT_DIR}/fs_roots/Ubuntu_22
declare_ut
which_linux distro_fullname distro_name
assert_equal "${distro_fullname} ${distro_name}" 'Ubuntu ubuntu'

ROOT_PREFIX=${SCRIPT_DIR}/fs_roots/Fedora_36
declare_ut
which_linux distro_fullname distro_name
assert_equal "${distro_fullname} ${distro_name}" 'Fedora Linux fedora'
