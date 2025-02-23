#!/usr/bin/env sh

echo "start nginx"
nginx -g 'daemon off;' &

echo "start php-fpm"
php-fpm8 -F &

# wait until one child exit
wait -n
