#!/bin/sh

echo "Waiting for MariaDB..."
while ! nc -z mariadb 3306; do
    sleep 2
done


curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

cd /var/www/wordpress

if [ ! -f "wp-config.php" ]; then
    
    DB_PASSWORD=$(cat /run/secrets/db_password)
    WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
    WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)
    
    wp config create --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${DB_PASSWORD} \
        --dbhost=mariadb \
        --allow-root
    
    wp core install --url="https://${DOMAIN_NAME}" \
        --title="Inception Blog" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root
    
    wp user create ${WP_USER} ${WP_USER_EMAIL} \
        --user_pass=${WP_USER_PASSWORD} \
        --role=author \
        --allow-root
fi

chown -R www-data:www-data /var/www/wordpress

exec php-fpm83 -F

touch /var/www/wordpress/ready
