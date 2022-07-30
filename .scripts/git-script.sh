#!/bin/bash
GREEN='\033[1;32m'
NC='\033[0m'
name=$1
repo="git@github.com:mariacdadalt/${name}.git"
folder="public/plugins/${name}"

echo -e "${GREEN}Cloning $name${NC}"
git clone $repo $folder --quiet
cd $folder
git checkout master