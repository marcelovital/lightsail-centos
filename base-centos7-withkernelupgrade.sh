#!/bin/bash
#
# base-centos7-withkernelupgrade.sh - Originally in https://github.com/marcelovital/lightsail-centos
#
# This script is intended to take a default CentOS 7 image (tested on "7 1901-01") from AWS , update and tweak it.
# Includes updated kernel to latest version in ELRepo.
#
# USAGE: In AWS Lightsail, create an instance and copy-paste this script into the "Launch Script" box.
#
# If you wish to follow the script's progress, ssh into the server after the instance is up and "tail -f /home/centos/centos-deploy.log".
# The full script is expected to run in about 15 minutes on a 1vCPU-1GbRAM ($5) instance. 


echo "======================================================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Create logfile in user centos's home folder and give full access to it" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "======================================================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

cat /etc/centos-release | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy-started
chown centos:centos /home/centos/centos-deploy*
chmod 666 /home/centos/centos-deploy*

echo "=========================================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Basic new server tasks: Update all packages, install EPEL" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "=========================================================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

yum update -y | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
yum install -y epel-release.noarch | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

echo "====================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Install useful tools" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "====================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

yum install -y yum-utils rpmconf podman buildah skopeo vim git wget ansible bash-completion bash-completion-extras setroubleshoot setools docker docker-compose | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
systemctl enable docker | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
yum upgrade -y | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

echo "========================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Upgrade to latest Kernel" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "========================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf install -y https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf --enablerepo=elrepo-kernel install -y kernel-ml | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
sudo awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
sudo grub2-set-default 0 | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
sudo grub2-mkconfig -o /boot/grub2/grub.cfg | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

echo "================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Cleanup and boot" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

yum -y update | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
yum clean all | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
mv /home/centos/centos-deploy-started /home/centos/centos-deploy-completed
cat /etc/centos-release | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy-completed
systemctl reboot  | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy-completed

# Deploy is finished. Remember to "sudo hostnamectl set-hostname your-hostname" and "sudo timedatectl set-timezone your-timezone" after boot
