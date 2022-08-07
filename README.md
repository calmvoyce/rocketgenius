# Workspace

Workspace is a Development Environment created to require minimum setup when creating a new project.

It makes use of vscode's devcontainer features, installing and configuring a set of extensions. 

This was especifically created to work with [WP Starter](https://wecodemore.github.io/wpstarter/).

## Dependencies

- Docker Desktop
- VSCode
- Composer

## Instalation

- Copy the following files, removing the `.example` extension from them and ensuring that all data represented by `{{ DATA_DESCRIPTION }}` is replaced by yours. For example: replace a `{{ YOUR_NAME }}` for `John Doe`.
	- `.env.example` in the *root* folder
	- `auth.json.example` in the *root* folder ( You will need to [Generate a Github Token](https://github.com/settings/tokens) )
	- `hosts.example` in the *.scripts* folder
	- `server.csr.cnf.example` in the *.scripts* folder
	- `v3.ext.example` in the *.scripts* folder

- Create a `.env` file inside the *public/wordpress.local* folder with the following content
````
WP_ENVIRONMENT_TYPE=local
````

- Open VSCode and use the option `File >>> Open Workspace from file` to open `my.code-workspace`

- Click in the green button in the bottom left corner of VSCode. Click on `Reopen in Container`

- The container will start to build. Keep an eye on the terminal, it will ask for your password so it can create the certificates.

- Go to [https://wordpress.local](https://wordpress.local) to see it working.

## How to add more projects