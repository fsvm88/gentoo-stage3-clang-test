# Dockerfile to build a gentoo minimal image for clang package testing
FROM scratch 

# Add the base gentoo setup
ADD stage3-amd64-20140619.tar /
MAINTAINER Fabio Scaccabarozzi <fsvm88@gmail.com>

ADD etc.tar /

ENV HOME /root

VOLUME ["/portage/distfiles", "/portage/gentoo", "/portage/local_overlay", "/portage/logs", "/portage/tmp"]

# Modify the makefile
ADD bootstrap_everything.sh /root/
RUN /bin/bash /root/bootstrap_everything.sh
RUN rm -f /root/bootstrap_everything.sh

# Set default cmd
CMD ["/bin/bash"]
