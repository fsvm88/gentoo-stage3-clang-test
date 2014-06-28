gentoo-stage3-clang-test
========================

**Scripts and tools to build and run docker images for clang package testing on Gentoo.**

Before running "docker build" or docker_cmds/buildClangTestImage.sh be sure to compress the etc directory.
    tar cpf etc.tar etc/

Beware that these scripts have been used 'til now in my (unusual) Gentoo setup. You are strongly encouraged to open them, understand them, and modify them to your needs.
Apart the bootstrap_everything.sh script, the two found in docker_cmds/ are extremely simple and short, they are just minimal wrappers.

The volumes
----

I have provided five default mount points in the Dockerfile.
They allow to share with the host the portage tree and the distfiles, while allowing to read from the host the temporary files and the logs.
Optionally, you can mount an overlay from the host.
For an hint on how to mount them, have a look at the docker_cmds/runNewClangTestInstance.sh script.
