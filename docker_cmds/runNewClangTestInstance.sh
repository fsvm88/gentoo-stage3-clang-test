#!/bin/bash

# Import some variables, if defined on host system
# Import only sharable items (portage tree, distfiles)
PORTDIR=$(grep "^PORTDIR=" /etc/portage/make.conf | sed -e 's:.*=::' -e 's:"::g')
DISTDIR=$(grep "^DISTDIR=" /etc/portage/make.conf | sed -e 's:.*=::' -e 's:"::g')
if [ -z "${PORTDIR+set}" ]; then PORTDIR="/usr/portage"; fi
if [ -z "${DISTDIR+set}" ]; then DISTDIR="/usr/portage/distfiles"; fi

# For the rest setup temporary directories
# I_ stands for "internal", opposed to makefile variables
TMPBASE=$(mktemp -d /tmp/gentoo-stage3-clang-test-XXXXXXXXXXXX)
I_TMPDIR="${TMPBASE}/tmp"
I_LOGDIR="${TMPBASE}/logs"
I_OVERLAY="${TMPBASE}/local_overlay"

mkdir -p $I_OVERLAY $I_LOGDIR $I_TMPDIR

docker run -t -i -rm -v "${PORTDIR}":/portage/gentoo -v "${DISTDIR}":/portage/distfiles -v "${I_OVERLAY}":/portage/local_overlay -v "${I_LOGDIR}":/portage/logs -v "${I_TMPDIR}":/portage/tmp fsvm88/gentoo-stage3-clang-test /bin/bash

echo "$TMPBASE will not be removed, as it may still contain useful data. Be sure to remove it once done."
