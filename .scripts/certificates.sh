#!/bin/bash

## Generate root Certificate
function cert_root_ca() {
	if [ ! -f ../.docker/nginx/certs/rootCA.key ]; then
    	openssl genrsa -des3 -passout pass:password -out ../.docker/nginx/certs/rootCA.key 2048
		openssl req -x509 -new -nodes -key ../.docker/nginx/certs/rootCA.key -sha256 -days 1460 -passin pass:password -out ../.docker/nginx/certs/rootCA.pem -config server.csr.cnf
	fi
}

function cert_generate() {
	if [ ! -f ../.docker/nginx/certs/server.csr ]; then
    	openssl req -new -sha256 -nodes -passin pass:password -out ../.docker/nginx/certs/server.csr -newkey rsa:2048 -keyout ../.docker/nginx/certs/server.key -config server.csr.cnf
		openssl x509 -req -in ../.docker/nginx/certs/server.csr -CA ../.docker/nginx/certs/rootCA.pem -CAkey ../.docker/nginx/certs/rootCA.key -CAcreateserial -passin pass:password -out ../.docker/nginx/certs/server.crt -days 500 -sha256 -extfile v3.ext
	fi
}

## Install the certificate
function cert_install() {
	cd ../.docker/nginx/certs
	if [[ "$OSTYPE" == "darwin"* ]]; then
		sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" server.crt
		echo "Root certificate has been added to the MAC client"
	elif [[ "$OSTYPE" == "linux-gnu" ]]; then
		sudo ln -s "server.crt" "/usr/local/share/ca-certificates/server.crt"
		sudo update-ca-certificates
		echo "Root certificate has been added to the Linux client"
	else
		echo "Could not install the certificate on the host machine, please do it manually"
	fi
}

case "$1" in
root)
	cert_root_ca
	;;
generate)
	cert_generate
	;;
install)
	cert_install
	;;
*)
	cat <<EOF

Certificate management commands.

Usage:
    bash certificates.sh <command>

Available commands:
    root ...................................... Generate root ca certificate. Needs server.csr.cnf file
	generate .................................. Generate a new certificate. Needs to be run after the root command. Relies on
												server.csr.cnf file and v3.ext file 
    install ................................... Install the certificate in the host machine. Cannot be run inside the docker 
												container

EOF
	;;
esac
