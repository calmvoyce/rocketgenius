#!/bin/bash

if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi

GREEN='\033[1;32m'
NC='\033[0m'

##  docker compose down -v --rmi all --remove-orphans
##  docker compose exec -w/var/www/projects/X php wp --allow-root db create
##  docker compose exec -w/var/www/projects/X php wp --allow-root --debug db import
##  docker compose exec -w/var/www/projects/X php wp --allow-root search-replace 'https://X.com' 'https://X.local'
##  docker compose exec -w/projects/local composer composer install

case "$1" in
init)
	bash gravity.sh workspace
	git config --global core.filemode false
	git config --global pull.rebase false
	bash .scripts/git-clone-list.sh repos.list
	composer install
	cd public
	wp db create
	wp core install --url=gravity.loc --title=Gravity --admin_user=admin --admin_password=admin --admin_email=$USER_MAIL
	;;
rebuild)
	docker compose up -d --build
	;;
restart)
	docker compose restart
	;;
start)
	docker compose start
	;;
stop)
	docker compose stop
	;;
down)
	docker compose down --rmi all --remove-orphans
	;;
cert)
	bash .scripts/certificates.sh root
	bash .scripts/certificates.sh generate
	bash .scripts/certificates.sh install
	;;
import)
	# put the file on .docker/mysql/files/{project_name}.sql
	# $2 is the project name
	# $3 is the project domain
	docker compose exec -w/var/www/projects/$2 php wp --allow-root db create
	bash .scripts/large-database.sh "$2.sql" $2
	docker compose exec -w/var/www/projects/$2 -- php wp --allow-root --debug search-replace "$3" "$2.local"
	docker compose exec -w/var/www/projects/$2 -- php wp --allow-root --debug search-replace "https://$3" "https://$2.local"
	docker compose exec -w/var/www/projects/$2 -- php wp --allow-root --debug search-replace "http://$3" "http://$2.local"
	;;
fix-permissions)
	docker compose exec nginx bash /.scripts/fix-wordpress-permissions.sh .
	;;
search-replace)
	# $2 is the project name
	# $3 is the domain to change
	docker compose exec -w/var/www/projects/$2 -- php wp --allow-root --debug search-replace "$3" "$2.local"
	docker compose exec -w/var/www/projects/$2 -- php wp --allow-root --debug search-replace "https://$3" "https://$2.local"
	docker compose exec -w/var/www/projects/$2 -- php wp --allow-root --debug search-replace "http://$3" "http://$2.local"
	docker compose exec -w/var/www/projects/$2 -- php wp --allow-root --debug search-replace "http://$2.local" "https://$2.local"
	;;
composer)
	docker compose exec php composer $1 $2
	;;
workspace)
	if [ ! -f /vscode/.ssh/id_rsa ]; then
    	ssh-keygen -v -t ed25519 -C $USER_MAIL -f /vscode/.ssh/id_rsa -N ''
	fi
	eval "$(ssh-agent -s)"
	ssh-add /vscode/.ssh/id_rsa
	printf "${GREEN}Copy the content bellow into the following github page: https://github.com/settings/ssh/new${NC} \n\n"
	cat /vscode/.ssh/id_rsa.pub
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
	;;
*)
	cat <<EOF

Command line interface for the Docker-based web development environment.

Usage:
    gravity <command> [options] [arguments]

Available commands:
    cert ...................................... Certificate management commands
         generate ............................. Generate a new certificate
         install .............................. Install the certificate
    init ...................................... Installs or Updates all projects inside the projects.json file. If no
                                                file is found, it creates one.
    update .................................... Installs or Updates all projects inside the projects.json file. If no
                                                file is found, it creates one.
    down [-v] ................................. Stop and destroy all containers
                                                Options:
                                                    -v .................... Destroy the volumes as well
    logs [container] .......................... Display and tail the logs of all containers or the specified one's
    restart ................................... Restart the containers
    start ..................................... Start the containers
    stop ...................................... Stop the containers


EOF
	exit 1
	;;
esac
