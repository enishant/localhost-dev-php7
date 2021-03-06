# Development Environment with PHP7

A simple Vagrant LAMP setup with PHP 7.1 running on Ubuntu Trusty 64.

## What's inside?

- Ubuntu (ubuntu/trusty64)
- Vim, Git, Curl, etc.
- Apache
- PHP 7.1 with some extensions
- MySQL 5.7
- Node.js 8 with NPM
- RabbitMQ
- Redis
- Composer
- phpMyAdmin

## Prerequisites
- [Vagrant](https://www.vagrantup.com/downloads.html)
- Plugin vagrant-vbguest (``vagrant plugin install vagrant-vbguest``)

## How to use

- Clone this repository into your project
- Run ``vagrant up``
- Run ``vagrant provision --provision-with example.com``
- Run ``vagrant provision --provision-with wpcli-install`` (Install WPCLI)
- Run ``vagrant provision --provision-with wordpressexample.com`` (Setup WordPress site)
- Run ``vagrant provision --provision-with wpcli-update`` (Update WPCLI)

- Add the following lines to your hosts file:
````
192.168.10.10 localhost.local
192.168.10.10 phpmyadmin.localhost.local
192.168.10.10 example.com
192.168.10.10 www.example.com
192.168.10.10 wordpressexample.com
192.168.10.10 www.wordpressexample.com
````
- Navigate to ``http://localhost.local/``
- Navigate to ``http://example.com/``
- Navigate to ``http://www.example.com/``
- Navigate to ``http://example.com/phpmyadmin`` (both username and password are 'root')
- Navigate to ``http://www.example.com/phpmyadmin`` (both username and password are 'root')
- Navigate to ``http://phpmyadmin.localhost.local/`` (both username and password are 'root')
- Navigate to ``http://www.wordpressexample.com/`` (WordPress admin username 'nishant' and password is 'password')
