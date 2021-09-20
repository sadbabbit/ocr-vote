#!/usr/bin/env bash

set -e

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi

FILEPATH="$1"
FILENAME="$(basename -- $FILEPATH)"
FILENAME_NO_EXTENSION="${FILENAME%.*}"

export PYTHONPATH=$PYTHONPATH:$(pwd)
export EXTRACT_DIR=processed/"$FILENAME_NO_EXTENSION"
mkdir -p "$EXTRACT_DIR"

python3 preprocess_image.py $FILEPATH
python3 table_ocr/extract_tables processed/"$FILENAME" | grep table > "$EXTRACT_DIR"/extracted-tables.txt
cat "$EXTRACT_DIR"/extracted-tables.txt | xargs -I{} python3 -m table_ocr.extract_cells {} | grep cells > "$EXTRACT_DIR"/extracted-cells.txt
cat "$EXTRACT_DIR"/extracted-cells.txt | xargs -I{} python3 -m table_ocr.ocr_image {}

mkdir -p result
echo -n "" > result/"$FILENAME_NO_EXTENSION".csv
for image in $(cat "$EXTRACT_DIR"/extracted-tables.txt); do
    dir=$(dirname $image)
    python3 -m table_ocr.ocr_to_csv $(find $dir/cells -name "*.txt") >> result/"$FILENAME_NO_EXTENSION".csv
done
cat result/"$FILENAME_NO_EXTENSION".csv