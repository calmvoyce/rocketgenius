#!/usr/bin/env bash

git clone git@github.com:gravityforms/houston.git /home/vscode/houston
cd /home/vscode/houston
nvm install 16.13.0
nvm use
npm install
npm link