#!/bin/sh

INPUT=$1
OUTPUT=$2
COLUMNS=${3:-10}

python ~/Documents/scripts/anim_combine.py -d $INPUT -o $OUTPUT-c $COLUMN
