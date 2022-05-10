#!/bin/bash

if [ -f .env ]; then
  export $(echo $(cat .env | sed 's/#.*//g'| xargs) | envsubst)
fi

##  docker compose down -v --rmi all --remove-orphans
##  docker compose exec -w/var/www/projects/X php wp --allow-root db create
##  docker compose exec -w/var/www/projects/X php wp --allow-root --debug db import
##  docker compose exec -w/var/www/projects/X php wp --allow-root search-replace 'https://X.com' 'https://X.local'
##  docker compose exec -w/projects/local composer composer install

case "$1" in
init)
	git config --global core.filemode false
	git config --global pull.rebase false
	./.scripts/git-clone-list.sh $PERSONAL_TOKEN repos.list
	docker compose up
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
	docker compose restart
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
	# $2 is the project name
	docker compose exec -w/var/www/projects/$2 php bash /.scripts/fix-wordpress-permissions.sh .
	docker compose exec -w/var/www/projects/$2 nginx bash /.scripts/fix-wordpress-permissions.sh .
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
