#!/bin/bash

if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi

GREEN='\033[1;32m'
NC='\033[0m'

case "$1" in
initialize-host)
	cd .scripts
	bash edit-host-file.sh
	bash certificates.sh root
	bash certificates.sh generate
	bash certificates.sh install
	;;
init)
	bash workspace.sh workspace
	git config --global core.filemode false
	git config --global pull.rebase false
	composer install
	cd public
	composer install
	wp db create
	wp core install --url=wordpress.local --title=WordPress --admin_user=admin --admin_password=admin --admin_email=$USER_MAIL
	;;
workspace)
	if [ ! -f /home/vscode/.ssh/id_rsa ]; then
    	ssh-keygen -v -t ed25519 -C $USER_MAIL -f /home/vscode/.ssh/id_rsa -N ''
	fi
	eval "$(ssh-agent -s)"
	ssh-add /home/vscode/.ssh/id_rsa
	printf "${GREEN}Copy the content bellow into the following github page: https://github.com/settings/ssh/new${NC} \n\n"
	cat /home/vscode/.ssh/id_rsa.pub
	printf "\n\n"
	read -p "Press any key when you're done..."
	ssh-add -l -E sha256

	#git configuration
	git config --global pull.rebase false
	git config --global user.name $USER_NAME
	git config --global user.email $USER_MAIL
	git config --global merge.tool vscode
	git config --global mergetool.vscode.cmd 'code --wait $MERGED'
	git config --global diff.tool vscode
	git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'

	ssh -T git@github.com
	
	phpcs --config-set installed_paths ../../automattic/phpcs-neutron-standard,../../automattic/vipwpcs,../../inpsyde/php-coding-standards,../../phpcompatibility/php-compatibility,../../sirbrillig/phpcs-variable-analysis,../../wp-coding-standards/wpcs
	;;
*)
	cat <<EOF

Command line interface of the Workspace project.

Usage:
    bash workspace.sh <command>

Available commands:
    initialize-host ........................... Command specific to be used in the host, NOT the Docker container
    init ...................................... Initiates the projects, installing composer dependencies
    workspace ................................. Runs configurations for the workspace, relies in .env file

EOF
	exit 1
	;;
esac
