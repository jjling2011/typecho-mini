#!/usr/bin/env bash

name=$1
if [ x"${name}" == x"" ]; then
    name="typecho-1.2.1"
fi

echo "remove image: ${name}"
docker image rm "${name}"

echo "build image: ${name}"
docker build . -t "${name}"
