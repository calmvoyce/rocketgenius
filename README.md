# Workspace

Workspace is a Development Environment created to require minimum setup when creating a new project.

It makes use of vscode's devcontainer features, installing and configuring a set of extensions. 

This was especifically created to work with [WP Starter](https://wecodemore.github.io/wpstarter/).

## Dependencies

- Docker Desktop
- VSCode
- Composer

## Instalation

- Copy the following files, removing the `.example` extension from them and ensuring that all data represented by `{{ DATA_DESCRIPTION }}` is replaced by yours. For example: replace a `{{ YOUR_NAME }}` with `John Doe`.
	- `my.code-workspace.example` in the *root* folder
	- `.env.example` in the *root* folder
	- `auth.json.example` in the *root* folder ( You will need to [Generate a Github Token](https://github.com/settings/tokens) )
	- `hosts.example` in the *.scripts* folder
	- `server.csr.cnf.example` in the *.scripts* folder
	- `v3.ext.example` in the *.scripts* folder

- Create a `.env` file inside the *public/wordpress.local* folder with the following content
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