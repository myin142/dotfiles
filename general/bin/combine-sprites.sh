#!/bin/sh

INPUT=${1:-_sprites}
OUTPUT=${2:-assets}
COLUMNS=${3:-10}

python ~/Documents/scripts/anim_combine.py -d $INPUT -o $OUTPUT -c $COLUMNS
