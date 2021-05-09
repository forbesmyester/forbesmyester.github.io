#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

if [ "$#" -gt 0 ] && [[ "$1" != "--as-markdown" ]]; then
    CURRENT="$(cat "$1")"
else
    CURRENT="$(cat "/dev/stdin")"
fi


echo "$CURRENT" | awk -f fix_header.awk | matts-markdown -b 2
echo ""
echo ""
