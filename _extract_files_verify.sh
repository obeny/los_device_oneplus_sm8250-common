#!/bin/bash

cat proprietary-files.txt.regen.clean | grep "|" | awk -F"|" '{print $1 " " $2}' |
while IFS= read -r line;
do
    FILE="$(cut -f 1 -d " " <<<${line})"
    FILE="$(cut -f 1 -d ";" <<<${FILE})"

    SUM_PINNED="$(cut -f 2 -d " " <<<${line})"
    SUM_CURR="$(sha1sum "blobs/${FILE}" | awk '{print $1}')"

    if [[ "${SUM_PINNED}" != "${SUM_CURR}" ]]; then
        echo "${FILE}: ${SUM_CURR} expected ${SUM_PINNED}"
    fi
done
