#!/bin/bash
GREEN='\033[1;32m'
NC='\033[0m'
token=$1
name=$2
repo="https://${token}@github.com/gravityforms/${name}"
folder="plugins/${name}"

echo -e "${GREEN}Cloning $name${NC}"
git clone $repo $folder
cd $folder
git checkout master