#!/bin/bash

if [[ $# != 1 ]]; then
    echo "usage: gen_propfiles.sh <propfile.txt>"
    exit 1
fi

cat "${1}" | grep -v "^#" | grep -v "^$" | sort > ${1}.clean
