#!/usr/bin/env bash

name=$1
if [ x"${name}" == x"" ]; then
    name="typecho-1.2.1"
fi

echo "run image: ${name}"
echo "press ctrl+p and ctrl+q to exit it mode"

docker run \
    --user root \
    --rm \
    -it \
    -p 443:443 \
    -v /path/to/rootfs/etc/nginx/conf.d/default.conf:/etc/nginx/conf.d/default.conf \
    -v /path/to/rootfs/var/www/html/:/var/www/html/ \
    --name ${name} \
    ${name} /bin/sh -l

echo "containers:"
docker container ls
