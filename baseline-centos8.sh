#!/bin/bash
yum update -y
yum install -y epel-release.noarch yum-utils rpmconf 
rm -f /etc/yum.repos.d/CentOS-Media.repo
yum update -y

yum install -y dnf
dnf remove -y yum yum-metadata-parser
rm -Rf /etc/yum
dnf update -y

dnf install -y http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/{centos-linux-release-8.3-1.2011.el8.noarch.rpm,centos-gpg-keys-8-2.el8.noarch.rpm,centos-linux-repos-8-2.el8.noarch.rpm}
dnf update -y epel-release
rpm -e `rpm -q kernel`
rpm -e --nodeps sysvinit-tools
dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync
dnf install -y kernel-core
dnf -y groupupdate "Core" "Minimal Install"

dnf install -y git vim wget ansible bash-completion setroubleshoot setools
dnf clean all