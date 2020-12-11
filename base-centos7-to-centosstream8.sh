#!/bin/bash
#
# base-centos7-to-centosstream8.sh - Originally in https://github.com/marcelovital/lightsail-centosstream
#
# This script is intended to take a default CentOS 7 image (tested on "7 1901-01") from AWS and change it into CentOS 8 and then into CentOS Stream 8
# Created after IBM/RedHat's announcement in December 2020 that it would no longer invest in CentOS Linux and focus investment in CentOS Stream instead.
#
# USAGE: In AWS Lightsail, create an instance and copy-paste this script into the "Launch Script" box.
#
# If you wish to follow the script's progress, ssh into the server after the instance is up and "tail -f /home/centos/centosstream-deploy.log".
# The full script is expected to run in about 15 minutes on a 1vCPU-1GbRAM ($5) instance.
# 
# The CentOS 7 to CentOS 8 part is based in the guide from CentLinux at https://www.centlinux.com/2020/01/how-to-upgrade-centos-7-to-8-server.html
# The CentOS 8 to CentOS Stream 8 is based in the original instructions in https://www.centos.org/centos-stream/ 

# Create logfile in user centos's root folder and give full access to it
touch /home/centos/centosstream-deploy.log
chown centos:centos /home/centos/centosstream-deploy.log
chmod 666 /home/centos/centosstream-deploy.log

# Basic new server tasks: Update all packages, install EPEL
yum update -y | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
yum install -y epel-release.noarch | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log

# Install the tools needed for this process, replace YUM by DNF
yum install -y yum-utils rpmconf dnf vim git wget | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
dnf remove -y yum yum-metadata-parser | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
rm -Rf /etc/yum | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
dnf upgrade -y | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log

# Install CentOS 8 and EPEL 8 Repos
dnf install -y http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/{centos-linux-release-8.3-1.2011.el8.noarch.rpm,centos-gpg-keys-8-2.el8.noarch.rpm,centos-linux-repos-8-2.el8.noarch.rpm} | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
dnf upgrade -y epel-release | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log

# Upgrade CentOS 7 to CentOS 8
rpm -e `rpm -q kernel` | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
rpm -e --nodeps sysvinit-tools python36-rpmconf | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
dnf install -y kernel-core | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
dnf -y groupupdate "Core" "Minimal Install" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log

# Switch from CentOS to CentOS Stream
dnf install -y centos-release-stream | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
dnf swap centos-{linux,stream}-repos | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
dnf -y distro-sync | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log

# Install latest Podman from Kubic Project
dnf -y module disable container-tools | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
dnf -y install 'dnf-command(copr)' | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
dnf -y copr enable rhcontainerbot/container-selinux | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/devel:kubic:libcontainers:stable.repo | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
dnf -y install podman | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log

# Cleanup and boot
dnf -y update | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
dnf clean all | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy.log
cat /etc/centos-release | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy-is-finished
systemctl reboot  | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centosstream-deploy-is-finished

# Deploy is finished. Remember to "hostnamectl set-hostname your-hostname" and "timedatectl set-timezone your-timezone" after boot