#!/bin/bash

CXLSTAT=../../cxlstat

if [[ ! -f "${CXLSTAT}" ]] ; then
    echo "Test script can't locate cxlstat"
    exit 1
fi

first=$(grep -n db4de81e-a31e-491d-a9dc-17a3e63be914 < "${CXLSTAT}" | cut -d : -f 1 | head -1)
last=$(grep -n db4de81e-a31e-491d-a9dc-17a3e63be914 < "${CXLSTAT}" | cut -d : -f 1 | tail -1)

(( start = first - 1 ))
(( stop  = last + 1 ))

eval sed -n "'${start},${stop}p'" < "${CXLSTAT}" > functions.sh

