# Workspace

Workspace is a Development Environment created to require minimum setup when creating a new project.

It makes use of vscode's devcontainer features, installing and configuring a set of extensions. 

This was especifically created to work with [WP Starter](https://wecodemore.github.io/wpstarter/).

## Dependencies

- Docker Desktop
- VSCode
- Composer

## Instalation

- Create a `.env` file inside the root folder with the folowing content
````
USER_MAIL=YOUR_GIT_EMAIL
USER_NAME=YOUR_COMMIT_NAME
````

- Create a `.env` file inside the public folder with the following content
````
WP_ENVIRONMENT_TYPE=local
````

- Open VSCode and use the option `File >>> Open Workspace from file` to open `my.code-workspace`

- Click in the green button in the bottom left corner of VSCode. Click on `Reopen in Container`

- The container will start to build. Keep an eye on the terminal, it will ask for your password, so it can create the certificates.

- Go to [https://wordpress.local](https://wordpress.local) to see it working.