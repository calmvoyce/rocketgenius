#!/bin/bash
while read -r line; do
  ./.scripts/git-script.sh $1 $line
done < "$2"