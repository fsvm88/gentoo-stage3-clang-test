#!/bin/bash

echo "Before running this script, make sure that all the variables are correctly set and that you have made a tarball of the etc/ directory provided."

#docker build --no-cache=true --tag="fsvm88/gentoo-stage3-clang-test" $(pwd)/../
docker build --no-cache=true --tag="<your docker hub nick>/<your new image name>" $(pwd)/../
