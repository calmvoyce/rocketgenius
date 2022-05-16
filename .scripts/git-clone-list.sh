#!/bin/bash
while read -r line; do
  bash .scripts/git-script.sh $line
done < "$1"