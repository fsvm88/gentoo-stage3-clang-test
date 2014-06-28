#!/bin/bash

sed -i -e 's:^PORTDIR.*::' -e 's:^DISTDIR.*::' -e 's:^PKGDIR.*::' /etc/portage/make.conf

(
cat <<'EOF'
# Add generic compile flags for image portability. Running in a container means the host CPU gets exposed 1:1, meaning GCC will use native and create all sorts of problems
CFLAGS="${CFLAGS} -mtune=generic"
CXXFLAGS="${CFLAGS} -mtune=generic"

# Optimize linker output and resolve all symbols at executable load time, can be very useful for catching missing deps
LDFLAGS="${LDFLAGS} -Wl,-O1,-z,now"

# Declare some needed variables.
# Please note that there is no distinction here between global and local USEs
USE="${USE} static-analyzer gold"
FEATURES="${FEATURES} -preserve-libs unmerge-orphans -fail-clean distlocks userpriv sandbox sfperms suidctl usersandbox userfetch userpriv buildpkg -parallel-fetch fixlafiles unknown-features-warn usersync -ccache collision-protect"
PYTHON_TARGETS="${PYTHON_TARGETS} python2_7"

# Parallelize the build a little
MAKEOPTS="-j4 --silent"

# Setup logging variables
PORTAGE_ELOG_CLASSES="warn error log"
PORTAGE_ELOG_SYSTEM="save_summary"

# Add --delete-before to reclaim inodes and space on small filesystems, in case you happen to hold the repositories there
PORTAGE_RSYNC_EXTRA_OPTS="--delete-before"

# Declare a basedir to help easily moving the rest
BASEDIR="/portage"

# Declare all sorts of directories one will want to export (to provide sharing with other docker images and avoid having to export everything by hand)
PORTDIR="${BASEDIR}/gentoo"
DISTDIR="${BASEDIR}/distfiles"
PORT_LOGDIR="${BASEDIR}/logs"
PORTDIR_OVERLAY="${BASEDIR}/local_overlay"
PORTAGE_TMPDIR="${BASEDIR}/tmp"

# PKGDIR is the only one we do not export
PKGDIR="${BASEDIR}/packages"
EOF
) >> /etc/portage/make.conf


echo -n "Updating environment..."
env-update && source /etc/profile
echo "[OK]"
sync
echo -n "Syncing portage..."
emerge --sync --quiet
echo "[OK]"
sync
eselect python set --python2 1
eselect python set --python3 1
eselect profile set 1
env-update && source /etc/profile
emerge -uDN @world --quiet --keep-going
emerge eix euses gentoolkit genlop llvm clang htop iotop iftop --quiet --keep-going -j4
rm -Rf /portage/distfiles/* /portage/gentoo/* /portage/local_overlay/* /portage/logs/* /portage/packages/* /usr/portage/*

echo -e 'FEATURES="${FEATURES} test"' >> /etc/portage/make.conf
