#!/bin/bash
#
# base-centos7-to-centosstream8.sh - Originally in https://github.com/marcelovital/lightsail-centos
#
# This script is intended to take a default CentOS 7 image (tested on "7 1901-01") from AWS and change it into CentOS 8 and then into CentOS Stream 8
# Created after IBM/RedHat's announcement in December 2020 that it would no longer invest in CentOS Linux and focus investment in CentOS Stream instead.
#
# USAGE: In AWS Lightsail, create an instance and copy-paste this script into the "Launch Script" box.
#
# If you wish to follow the script's progress, ssh into the server after the instance is up and "tail -f /home/centos/centos-deploy.log".
# The full script is expected to run in about 15 minutes on a 1vCPU-1GbRAM ($5) instance. 
# 
# The CentOS 7 to CentOS 8 part is based in the guide from CentLinux at https://www.centlinux.com/2020/01/how-to-upgrade-centos-7-to-8-server.html
# The CentOS 8 to CentOS Stream 8 is based in the original instructions in https://www.centos.org/centos-stream/ 

echo "======================================================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Create logfile in user centos's home folder and give full access to it" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "======================================================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

cat /etc/centos-release | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy-started
chown centos:centos /home/centos/centos-deploy*
chmod 666 /home/centos/centos-deploy*

echo "=========================================================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Basic new server tasks: Update all packages, install EPEL and build tools" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "=========================================================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

yum update -y | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
yum install -y epel-release.noarch | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
rm -f /etc/yum.repos.d/CentOS-Media.repo | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
yum --enablerepo='*' install -y git make automake autoconf gettext libtool gcc libcap-devel systemd-devel yajl-devel libseccomp-devel python36 libtool golang | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

echo "========================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Install useful tools, replace YUM by DNF" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "========================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

yum install -y yum-utils rpmconf dnf vim wget ansible bash-completion bash-completion-extras setroubleshoot setools | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf remove -y yum yum-metadata-parser | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
rm -Rf /etc/yum | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf upgrade -y | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

echo "=================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Install CentOS 8 and EPEL 8 Repos" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "=================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

dnf install -y http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/{centos-linux-release-8.3-1.2011.el8.noarch.rpm,centos-gpg-keys-8-2.el8.noarch.rpm,centos-linux-repos-8-2.el8.noarch.rpm} | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf upgrade -y epel-release | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

echo "============================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Upgrade CentOS 7 to CentOS 8" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "============================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

rpm -e `rpm -q kernel` | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
rpm -e --nodeps sysvinit-tools python36-rpmconf | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf install -y kernel-core | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf -y groupupdate "Core" "Minimal Install" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

echo "===================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Switch from CentOS to CentOS Stream" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "===================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

dnf install -y centos-release-stream | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf swap -y centos-{linux,stream}-repos | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf -y --allowerasing distro-sync | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

echo "================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Cleanup and boot" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

dnf -y update | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf clean all | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
mv /home/centos/centos-deploy-started /home/centos/centos-deploy-completed
cat /etc/centos-release | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy-completed
systemctl reboot  | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy-completed

# Deploy is finished. Remember to "sudo hostnamectl set-hostname your-hostname" and "sudo timedatectl set-timezone your-timezone" after boot