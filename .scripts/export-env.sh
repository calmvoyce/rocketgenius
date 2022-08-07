#!/bin/sh

## Usage:
##   . ./export-env.sh ; $COMMAND

unamestr=$(uname)
if [ "$unamestr" = 'Linux' ]; then

  export $(grep -v '^#' $1/.env | xargs -d '\n')

elif [ "$unamestr" = 'FreeBSD' ] || [ "$unamestr" = 'Darwin' ]; then

  export $(grep -v '^#' $1/.env | xargs -0)

fi
