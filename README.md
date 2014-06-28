gentoo-stage3-clang-test
========================

**Scripts and tools to build and run docker images for clang package testing on Gentoo.**

Before running "docker build" or docker_cmds/buildClangTestImage.sh be sure to compress the etc directory.
    tar cpf etc.tar etc/

Beware that these scripts have been used 'til now in my (unusual) Gentoo setup. You are strongly encouraged to open them, understand them, and modify them to your needs.
Apart the bootstrap_everything.sh script, the two found in docker_cmds/ are extremely simple and short, they are just minimal wrappers.
