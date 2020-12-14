#!/bin/bash
dnf install -y http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/{centos-linux-release-8.3-1.2011.el8.noarch.rpm,centos-gpg-keys-8-2.el8.noarch.rpm,centos-linux-repos-8-2.el8.noarch.rpm}
dnf update -y epel-release
dnf remove -y bash-completion-extras
rpm -e `rpm -q kernel`
rpm -e --nodeps sysvinit-tools pycairo python3-3.6.8 python2-jmespath
dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync
dnf install -y kernel-core
dnf -y groupupdate "Core" "Minimal Install"