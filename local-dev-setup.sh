#! /bin/bash

# configuration
SOURCE_DIR=/mnt/c/Users/Taylor/Documents/dev/wordpress-gitlab-ci
DEST_DIR=/mnt/c/Users/Taylor/Documents/dev/wordpress-gitlab-ci-html-wrapper

LOCAL_SITE_URL=http://localhost:8080/wordpress-gitlab-ci-html-wrapper/
THEME_NAME=myBlog

WP_DB_HOST=localhost
WP_DB_NAME=<db-name>
WP_DB_USER=<db-user>
WP_DB_PASS=<db-pass>

# script main

cd $DEST_DIR

# delete all files except uploads
find $DEST_DIR -mindepth 1 ! -regex '^$DEST_DIR/wp-content/uploads\(/.*\)?' -delete

# install wordpress and plugins; configure db
wp core download --allow-root --version=5.8.1 --skip-content
wp core config --allow-root --dbname=$WP_DB_NAME --dbuser=$WP_DB_USER --dbpass=$WP_DB_PASS --dbhost=$WP_DB_HOST
wp plugin install --allow-root ewww-image-optimizer google-sitemap-generator wp-sweep

# load in custom theme
mkdir -p $DEST_DIR/wp-content/themes/
ln -s $SOURCE_DIR/wp-content/themes/$THEME_NAME $DEST_DIR/wp-content/themes/$THEME_NAME

# build theme dependencies
cd $DEST_DIR/wp-content/themes/$THEME_NAME
composer install
npm install

# activate theme and plugins
cd $DEST_DIR
wp theme activate --allow-root $THEME_NAME
wp plugin activate --allow-root ewww-image-optimizer google-sitemap-generator wp-sweep

# adjust config to set hostname
cd $DEST_DIR
wp config set --allow-root WP_SITEURL $LOCAL_SITE_URL
wp config set --allow-root WP_HOME $LOCAL_SITE_URL