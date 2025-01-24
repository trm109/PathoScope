#!/usr/bin/env bash

# Check if example/MAP_3852_align.sam exists, if not, attempt unzip via tar
if [ ! -f example/MAP_3852_align.sam ]; then
    echo "example/MAP_3852_align.sam not found, attempting to unzip example/MAP_3852_align.sam.tar.gz"
    tar -xvzf example/example_sam.tar.gz -C example/
fi

echo "python pathoscope/pathoscope2.py  ID -alignFile example/MAP_3852_align.sam -expTag 3852 -outDir results"
python pathoscope/pathoscope2.py  ID -alignFile example/MAP_3852_align.sam -expTag 3852 -outDir results

echo "python pathoscope/pathoscope2.py  REP -samfile results/updated_MAP_3852_align.sam -outDir results"
python pathoscope/pathoscope2.py  REP -samfile results/updated_MAP_3852_align.sam -outDir results

echo "done"
