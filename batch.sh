#!/usr/bin/env bash

set -e

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi

for f in $1/*; do
  echo "Processing $f"
  /root/ocr-vote/run.sh "$f"
done
