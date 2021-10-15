# WordPress Auto-deployment using GitLab CI/CD

A sample project that demonstrates how to auto-deploy a WordPress site using GitLab CI/CD. Deployments are handled over SSH. 

![GitLab Auto Deployment Process](https://taylor.callsen.me/wp-content/uploads/2021/10/GitLab_CI_Deployment_of_WordPress_Site-Taylor_Callsen_October_2021.jpg)

**Note**: The process described in this project **does not** modify or deploy content stored in the database or on the filesystem in `wp-content/uploads/*`.

## Repository Structure

This repo contains code needed for custom WordPress themes and plugins only. Core WordPress files, and configs are omitted, and will be downloaded/generated automatically by [WP-CLI](https://wp-cli.org/) as part of the CI and local development scripts.

This sample repo contains a theme called `myBlog`, which was generated using the [_s](https://github.com/Automattic/_s) starter theme.

## Dependencies

The following dependencies are required for local development, and should also be available on the Destination Deployment server:

- [WP-CLI](https://wp-cli.org/)
- NodeJS and NPM
- Composer

## Local Development

The recommended configuration is to create a wrapper directory and point the local webserver to it (referred to as the `DEST_DIR` below). Once ready, the `local-dev-setup.sh` script can be executed to install the WordPress Core, and load the custom `myBlog` theme included in this repo.

Configuration variables are available at the tope of the `local-dev-setup.sh`, including:

- `SOURCE_DIR` - local absolute path to where this git repo resides. Theme source files will be copied from this directory.
- `DEST_DIR` - local absolute path to the wrapper directory that the local webserver is pointing to. WordPress Core will be installed here, and theme source files will be copied to this directory.
- WordPress database connection information - specifies the database host, name, user, and password.

After executing the `local-dev-setup.sh` script, the WordPress instance residing at `DEST_DIR` should be available through the local webserver.

## GitLab Deployment Configuration

Changes will be deployed automatically to the Destination Server over an SSH connection.

### Deployment SSH User

An SSH user must be available on the Destination Server so that GitLab CI/CD can open an SSH sessin into the Destination Server, copy over source files, and execute build commands on the server. 

Steps 3-5 on this [DigitalOcean Guide](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-continuous-deployment-pipeline-with-gitlab-ci-cd-on-ubuntu-18-04#step-3-%E2%80%94-creating-a-deployment-user) cover how to create an SSH user and keys on a Destination Server. Once available, the user and keys can be loaded into the following CI/CD variables in GitLab, defined at either the group or project level:

- `STAGE_SERVER_IP` - contains the IP address of the Destination Server. This is the IP address used to make SSH connections from the GitLab Runner.
- `STAGE_SERVER_USER` - contains the user used when opening the SSH session.
- `STAGE_ID_RSA` - SSH private key used to authenticate when opening the SSH session.

**Note**: make sure the SSH user created has write access to the webserver directory and the ability to execute binaries like `npm` and `composer`.

### WordPress Connection Information

After configuring the SSH connection information, ensure the following WordPress specific CI/CD variables are available to the GitLab project:

- `STAGE_WORDPRESS_DB_HOST` - WordPress databsae host.
- `STAGE_WORDPRESS_DB_NAME` - WordPress databsae name.
- `STAGE_WORDPRESS_DB_USER` - WordPress databsae user.
- `STAGE_WORDPRESS_DB_PASSWORD` - WordPress databsae password.

### Deployment Paths

Configuration variables are defined at the top of the `.gitlab-ci.yaml` file that specify important deployment paths including:

- `WORDPRESS_SITE_DIR` - absolute path on the Destination Server where WordPress Core files should be installed, and custom theme files will be copied into. The Destination Server's webserver should be pointing to this directory.
- `NODE_BIN_PATH` and `COMPOSER_BIN_PATH` - NodeJS and Composer are required for building the Underscore theme artifacts. Ensure that these variables are configured with the absolute path to where these binaries reside on the Destination Server.

## Supplemental Blog Post

Here is a blog post I created that explains this project and the CI/CD process in further detail: Coming Soon