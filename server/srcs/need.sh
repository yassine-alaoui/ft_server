apt update
apt upgrade -y
apt install wget nginx php-mbstring unzip supervisor -y
apt install php7.3-fpm -y
apt-get -y install supervisor
apt install gdebi -y
apt install php-mysql -y

#nginx
mv /default /etc/nginx/sites-enabled/
echo "daemon off;" >> /etc/nginx/nginx.conf

#phpmyadmin
wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-all-languages.zip
unzip *.zip
mv phpMyAdmin-5.0.1-all-languages /var/www/html/phpmyadmin

#fix errors
mkdir -p /var/www/html/phpmyadmin/tmp
chmod 777 /var/www/html/phpmyadmin/tmp
cp /config.inc.php /var/www/html/phpmyadmin/
service php7.3-fpm start

#mysql
wget https://dev.mysql.com/get/mysql-apt-config_0.8.14-1_all.deb
export DEBIAN_FRONTEND=noninteractive
echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.7" | /usr/bin/debconf-set-selections
gdebi -n mysql-apt-config_0.8.14-1_all.deb
apt-get update
apt-get install mysql-server -y

chown -R mysql: /var/lib/mysql
service mysql start

#creat user & database
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'yassine'@'localhost' IDENTIFIED BY 'yassine';"
mysql -u root -e "CREATE DATABASE wp_db;"
mysql -u root -e "FLUSH PRIVILEGES;";

#wordpress
wget https://wordpress.org/latest.tar.gz
tar -zxvf latest.tar.gz
mv wordpress /var/www/html/wordpress
chown -R www-data:www-data /var/www/html/wordpress/
chmod -R 755 /var/www/html/wordpress/
cp -R var/www/html/wordpress/* var/www/html/
cp wp-config.php var/www/html/
mysql -u root wp_db < wp_db.sql

#install supervisord
cd /
mkdir -p /var/log/supervisor;
mkdir -p /etc/supervisor/conf.d;
mv supervisord.conf /etc/supervisord.conf;
