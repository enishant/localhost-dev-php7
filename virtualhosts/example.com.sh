echo "-- Creating virtual host example.com --"
mkdir /vagrant/www/example.com
sudo ln -fs /vagrant/www/example.com/ /var/www/example.com
cat << EOF | sudo tee -a /etc/apache2/sites-available/default.conf
<VirtualHost *:80>
    DocumentRoot /var/www/example.com
    ServerName example.com
    ServerAlias www.example.com
    Alias /phpmyadmin /var/www/phpmyadmin
</VirtualHost>
EOF

sudo /etc/init.d/apache2 restart