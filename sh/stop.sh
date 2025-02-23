#!/usr/bin/env bash

name=$1
if [ x"${name}" == x"" ]; then
    name="typecho-1.2.1"
fi

echo "stop container ${name}"
docker container stop "${name}"

echo "remove container ${name}"
docker container rm "${name}"
