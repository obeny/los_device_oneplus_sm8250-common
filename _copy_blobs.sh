#!/bin/bash

if [[ $# != 1 ]]; then
    echo "usage: copy_blobs.sh <roms_dir>"
    exit 1
fi

ROMS_DIR="${1}"
if [[ ! -d "${ROMS_DIR}" ]]; then
    echo "ERROR: ${ROMS_DIR} doesn't exist, exitting!"
    exit 1
fi

mkdir -p blobs

while read -r line
do
    grep -q "^#" <<<"${line}" && continue

    GROUP="$(cut -f 1 -d " " <<<"${line}")"
    ROM="$(cut -f 2 -d " " <<<"${line}")"
    echo "${GROUP} - ${ROM}:"
    ./_copy_files.sh "proprietary-files.txt._${GROUP}.src" "${ROMS_DIR}/${ROM}/dump" blobs
done < proprietary-src.txt

for i in $(find pinned -type f); do
    DIR="$(dirname "${i}" | cut -f 2- -d "/")"
    echo "pinned -> ${DIR}"
    mkdir -p "blobs/${DIR}"
    cp -av "${i}" "blobs/${DIR}"
done
