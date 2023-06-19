#!/bin/bash

# Start php-fpm in the background
php-fpm &

# Run Laravel's artisan commands
php artisan key:generate
php artisan config:clear

# Bring php-fpm back to the foreground for Docker
wait %1