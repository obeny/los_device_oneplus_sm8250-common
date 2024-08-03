#!/bin/bash

if [[ $# != 3 ]]; then
    echo "usage: copy_files.sh <list_file> <src> <blobs>"
    exit 1
fi

LIST_FILE="${1}"
SRC_DIR="${2}"
DST_DIR="${3}"

if [[ ! -e "${LIST_FILE}" ]]; then
    echo "LIST_FILE - ${LIST_FILE} invalid!"
fi

if [[ ! -d "${SRC_DIR}" ]]; then
    echo "SRC_DIR - ${SRC_DIR} invalid"!
    exit 1
fi

if [[ ! -d "${DST_DIR}" ]]; then
    echo "DST_DIR - ${DST_DIR} invalid"!
    exit 1
fi

for i in $(cat "${LIST_FILE}" | grep -v "^#" | grep -v "^$" | cut -f "1" -d "|" | sed -e 's/^-//')
do
    DST=""
    if grep -q ":" <<<${i}; then
        DST="$(cut -f 2 -d ":" <<<${i})"
    fi

    SRC="$(cut -f 1 -d ":" <<<${i})"
    SRC="$(cut -f 1 -d ";" <<<${SRC})"
    if [[ -z "${DST}" ]]; then
        DST="${SRC}"
        echo "${SRC}"
    else
        echo "${SRC} -> ${DST}"
    fi

    mkdir -p "$(dirname "${DST_DIR}/${DST}")"
    cp -a "${SRC_DIR}/${SRC}" "${DST_DIR}/${DST}"
done
