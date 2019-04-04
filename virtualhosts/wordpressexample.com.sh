DOMAIN_NAME="wordpressexample.com"
DATABASE="wordpressexample"
DB_USER="root"
DB_PASS="root"
echo "-- Creating virtual host $DOMAIN_NAME --"
mkdir /vagrant/www/$DOMAIN_NAME
sudo ln -fs /vagrant/www/$DOMAIN_NAME/ /var/www/$DOMAIN_NAME

cat << EOF | sudo tee -a /etc/apache2/sites-available/default.conf
<VirtualHost *:80>
    DocumentRoot /var/www/$DOMAIN_NAME
    ServerName $DOMAIN_NAME
    ServerAlias www.$DOMAIN_NAME
    Alias /phpmyadmin /var/www/phpmyadmin
</VirtualHost>
EOF

sudo /etc/init.d/apache2 restart

# WP Installation Directory
cd /vagrant/www/$DOMAIN_NAME

# Download WordPress
wp core download --locale=en_US --allow-root

# Create Database
mysql -uroot -proot -e "CREATE DATABASE $DATABASE";

# Create WordPress Configuration File
wp config create --dbname=$DATABASE --dbuser=$DB_USER --dbpass=$DB_PASS --allow-root --extra-php <<PHP

/* WordPress debug mode for developers. */
define( 'WP_DEBUG',         true );
define( 'WP_DEBUG_LOG',     true );
define( 'WP_DEBUG_DISPLAY', false );
define( 'SCRIPT_DEBUG',     true );
define( 'SAVEQUERIES',      true );

/* Compression */
define( 'COMPRESS_CSS',        true );
define( 'COMPRESS_SCRIPTS',    true );
define( 'CONCATENATE_SCRIPTS', true );
define( 'ENFORCE_GZIP',        true );

/* Updates */
define( 'WP_AUTO_UPDATE_CORE', true );
define( 'DISALLOW_FILE_MODS', true );
define( 'DISALLOW_FILE_EDIT', true );
define( 'FS_METHOD', 'direct' );

PHP

# Install WordPress
wp core install --url=www.$DOMAIN_NAME --title=$DOMAIN_NAME --admin_user=nishant --admin_password=password --admin_email=nishant@vaity.tech --skip-email --allow-root

# Rewrite Rule
wp rewrite flush --allow-root
wp rewrite structure '/%postname%/' --allow-root

cat << EOF | tee -a /var/www/$DOMAIN_NAME/.htaccess
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
EOF

# Install & Activate Plugins
wp plugin install jetpack --activate --allow-root
wp plugin install advanced-custom-fields --activate --allow-root
wp plugin install wck-custom-fields-and-custom-post-types-creator --activate --allow-root
wp plugin install classic-editor --activate --allow-root
wp plugin install health-check --activate --allow-root
wp plugin install contact-form-7 --activate --allow-root
wp plugin install easy-wp-smtp --activate --allow-root
wp plugin install the-preloader --activate --allow-root
wp plugin install broken-link-checker --activate --allow-root
wp plugin install easy-google-fonts --activate --allow-root
wp plugin install responsive-lightbox --activate --allow-root
wp plugin install tawkto-live-chat --activate --allow-root
wp plugin install wordpress-seo --version=4.8 --activate --allow-root

# Install & Activate Themes
wp theme install clean-bloggist --activate --allow-root

# Remove Plugins
wp plugin delete hello --allow-root
wp plugin delete akismet --allow-root

# Remove Themes
wp theme delete twentyseventeen --allow-root
wp theme delete twentysixteen --allow-root
wp theme delete twentynineteen --allow-root

# Update WordPress
wp core update --allow-root

# Update Database
wp core update-db --allow-root

# Delete revisions
wp post delete $(wp post list --post_type='revision' --format=ids --allow-root) --allow-root

# Delete transient
wp transient delete --all --allow-root
