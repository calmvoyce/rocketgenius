# Workspace

Workspace is a Development Environment created to require minimum setup when creating a WordPress project. It makes use of vscode's devcontainer features, installing and configuring a set of extensions. It will also setup a default project using the [WP Starter](https://wecodemore.github.io/wpstarter/) project as a base.

## Features

## Dependencies

- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [VSCode](https://code.visualstudio.com/Download)

## Instalation

- Copy the following files, removing the `.example` extension from them and ensuring that all data represented by `{{ DATA_DESCRIPTION }}` is replaced by yours. For example: replace a `{{ YOUR_NAME }}` with `John Doe`.
	- `my.code-workspace.example` in the **root** folder
	- `.env.example` in the **root** folder
	- `auth.json.example` in the **root** folder ( You will need to [Generate a Github Token](https://github.com/settings/tokens) )
	- `hosts.example` in the **.scripts** folder
	- `server.csr.cnf.example` in the **.scripts** folder
	- `v3.ext.example` in the **.scripts** folder
	- `composer.json.example` in the **public/wordpress.local** folder

- Create a `.env` file inside the **public/wordpress.local** folder with the following content
```
WP_ENVIRONMENT_TYPE=local
```

- Open VSCode and use the option `File >>> Open Workspace from file` to open `my.code-workspace`

- Click in the green button in the bottom left corner of VSCode. Click on `Reopen in Container`

- The container will start to build. Keep an eye on the terminal, it will ask for your password so it can create the certificates.

- Go to [https://wordpress.local](https://wordpress.local) to see it working.

## Personalizing my workspace

The `my.code-workspace` is a powerful file. The file is not commited in the repository (only a example of it) to allow you a degree of personalization. The most common personalization you might require is the folders you want to make available in the workspace. You can achieve this by editing the array called folders. The example has only one folder listed, the root folder. but you can add more folders to it, like the example below:

```
"folders": [
	{
		"path": "public/wordpress.local/wp-content/plugins/my-plugin"
	},
	{
		"path": "public/wordpress.local/wp-content/mu-plugins/plugin-core"
	},
	{
		"path": "public/my-project"
	},
	{
		"path": "."
	}
]
```

Keep in mind that the order of the folders will always be respected and you don't need to keep the root folder in your workspace, if you don't want to.

## How to add more projects

Since this workspace is powered by a nginx server, it is possible to have more projects than the one setup by default. This project doesn't need to be a WordPress one, but as this workspace is heavily aimed at it, we will assume that the project you want to create is a WordPress site using the [WP Starter](https://wecodemore.github.io/wpstarter/) project as a base.

- Create your folder project inside the `public` folder, using the pattern `{{ YOUR_PROJECT_NAME }}.local`
- Copy the files `composer.json.example`, `.env` and `.env.local` inside the **public/wordpress.local** folder to your newly created folder and remove the `.example` extension where applicable. Replace the `{{ DATA }}` placeholders with your information.
- Inside your folder, change the following variables in the `.env.local` file:
```
DB_NAME={{ YOUR_PROJECT_NAME }}
WP_HOME=https://{{ YOUR_PROJECT_NAME }}.local
```
- Duplicate the file `wordpress.conf.example` inside the **.docker/nginx/conf.d** folder, renaming it to the following pattern `{{ YOUR_PROJECT_NAME }}.conf`, then open the file and replace all instances of `{{ YOUR_PROJECT_NAME }}` with the real data.
- Edit the file `v3.ext` inside the **.scripts** folder and add the following line
```
DNS.3 = {{ YOUR_PROJECT_NAME }}.local
```
	- Don't forget to replace the placeholder with the name of your project
	- If you have more projects, you may need to change the number of the DNS entry to the number of the line you're at.
- Edit the `hosts` file inside the **.scripts** folder, adding the following lines before the `## End Local Host ##` tag.
```
::1 {{ YOUR_PROJECT_NAME }}.local #Local Site
127.0.0.1 {{ YOUR_PROJECT_NAME }}.local #Local Site
```
- Now you need to rebuild the container, so nginx knows your project exists. Click the the Green Button in the botton left of the vscode environment it should read `Dev Container: WORDPRESS` and select the option `Rebuild Container`. It should take a while, but once your environment opens up again, you should be able to open `https://{{ YOUR_PROJECT_NAME }}.local` without any problems.