chown -R mysql: /var/lib/mysql;
cp -R var/www/html/wordpress/* var/www/html/;
supervisord -c /etc/supervisord.conf;