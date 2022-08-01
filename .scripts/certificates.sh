#!/bin/bash

## Generate root Certificate
function cert_root_ca() {
	openssl genrsa -des3 -passout pass:password -out .docker/nginx/certs/rootCA.key 2048
	openssl req -x509 -new -nodes -key .docker/nginx/certs/rootCA.key -sha256 -days 1460 -passin pass:password -out .docker/nginx/certs/rootCA.pem -config .scripts/server.csr.cnf
}

function cert_generate() {
	openssl req -new -sha256 -nodes -passin pass:password -out .docker/nginx/certs/server.csr -newkey rsa:2048 -keyout .docker/nginx/certs/server.key -config .scripts/server.csr.cnf
	openssl x509 -req -in .docker/nginx/certs/server.csr -CA .docker/nginx/certs/rootCA.pem -CAkey .docker/nginx/certs/rootCA.key -CAcreateserial -passin pass:password -out .docker/nginx/certs/server.crt -days 500 -sha256 -extfile .scripts/v3.ext
}

## Install the certificate
function cert_install() {
	if [[ "$OSTYPE" == "darwin"* ]]; then
		sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ".docker/nginx/certs/server.crt"
	elif [[ "$OSTYPE" == "linux-gnu" ]]; then
		sudo ln -s "$(pwd)/.docker/nginx/certs/server.crt" "/usr/local/share/ca-certificates/server.crt"
		sudo update-ca-certificates
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
    workspace cert <command>

Available commands:
    generate .................................. Generate a new certificate
    install ................................... Install the certificate

EOF
	;;
esac
