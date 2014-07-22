#!/bin/bash

set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

stage3="$(wget -qO- 'http://distfiles.gentoo.org/releases/amd64/autobuilds/latest-stage3-amd64.txt' | tail -n1)"

if [ -z "$stage3" ]; then
	echo >&2 'wtf failure'
	exit 1
fi

url="http://distfiles.gentoo.org/releases/amd64/autobuilds/$stage3"
name="$(basename "$stage3")"

( set -x; wget -N "$url" )

base="${name%%.*}"
image="gentoo-temp:$base"
container="gentoo-temp-$base"

( set -x; tar cpSf etc.tar etc/ )

(
set -x;
cat <<EOF
# Dockerfile to build a gentoo minimal image for clang package testing
FROM scratch

# Add the base gentoo setup
ADD $name /
MAINTAINER Fabio Scaccabarozzi <fsvm88@gmail.com>

ADD etc.tar /

ENV HOME /root

VOLUME ["/portage/distfiles", "/portage/gentoo", "/portage/local_overlay", "/portage/logs", "/portage/tmp"]

# Modify the makefile
ADD additions/bootstrap_everything.sh /root/
RUN /bin/bash /root/bootstrap_everything.sh
RUN rm -f /root/bootstrap_everything.sh

# Set default cmd
CMD ["/bin/bash"]
EOF
) >> Dockerfile
