#!/bin/bash

source test_utils.sh
source functions.sh

declare_ut
version_to_major_minor 72.1-1 major minor
assert_equal "72 1" "${major} ${minor}"

declare_ut
version_to_major_minor 8.2.3995 major minor
assert_equal "8 2" "${major} ${minor}"

declare_ut
version_to_major_minor 1.18.6 major minor
assert_equal "1 18" "${major} ${minor}"

declare_ut
version_to_major_minor 20190730 major minor
assert_equal "20190730 0" "${major} ${minor}"

declare_ut
version_to_major_minor 2021.2.52 major minor
assert_equal "2021 2" "${major} ${minor}"

declare_ut
version_to_major_minor 265 major minor
assert_equal "265 0" "${major} ${minor}"

declare_ut
version_to_major_minor 6.24 major minor
assert_equal "6 24" "${major} ${minor}"

declare_ut
version_to_major_minor 0.4.2.0 major minor
assert_equal "0 4" "${major} ${minor}"

declare_ut
assert_false "version_gt 9 1 10 0"

declare_ut
assert_false "version_gt 9 1 10 1"

declare_ut
assert_false "version_gt 10 1 10 1"

declare_ut
assert_true "version_gt 10 1 10 0"

declare_ut
assert_true "version_gt 10 1 9 10"

declare_ut
assert_false "version_gte 9 0 10 0"

declare_ut
assert_false "version_gte 9 1 10 0"

declare_ut
assert_false "version_gte 9 1 10 1"

declare_ut
assert_true "version_gte 10 1 10 1"

declare_ut
assert_true "version_gte 10 1 10 0"

declare_ut
assert_true "version_gte 10 1 9 10"
