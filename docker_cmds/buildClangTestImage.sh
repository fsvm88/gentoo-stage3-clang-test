#!/bin/bash

echo "Before running this script, make sure that all the variables are correctly set and that you have made a tarball of the etc/ directory provided."

#docker build --no-cache=true --tag="<your docker hub nick>/<your new image name>" $(dirname $0)/../
if [ -n ${1+set} ]; then
	docker build --no-cache=true --tag="fsvm88/gentoo-stage3-clang-test" $(dirname $0)/../
fi
