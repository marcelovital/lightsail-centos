#!/bin/bash
echo "========================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Upgrade to latest Kernel" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "========================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf install -y https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf --enablerepo=elrepo-kernel install -y kernel-ml | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
sudo awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
sudo grub2-set-default 0 | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
sudo grub2-mkconfig -o /boot/grub2/grub.cfg | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
