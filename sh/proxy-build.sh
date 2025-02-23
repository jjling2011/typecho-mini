#!/usr/bin/env bash

IMAGE_NAME="typecho-1.2.1"

if [ $# -lt 1 ]; then
    echo "usage:"
    echo "$(basename "$0") 192.168.1.200 [port] [name]"
    echo "defaults: prot=8080 name=${IMAGE_NAME}"
    exit 0
fi

ip=$1
port=$2
if [ x"${port}" == x"" ]; then
    port="8080"
fi

name=$3
if [ x"${name}" == x"" ]; then
    name="${IMAGE_NAME}"
fi

myproxy="http://${ip}:${port}/"

echo "remove image: ${name}"
docker image rm "${name}"

echo "building: ${name}"
echo "using proxy: ${myproxy}"

docker build --build-arg HTTP_PROXY=${myproxy} \
    --build-arg HTTPS_PROXY=${myproxy}  \
    --build-arg http_proxy=${myproxy}  \
    --build-arg https_proxy=${myproxy}  \
    -t "${name}" \
    .
