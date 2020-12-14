#!/bin/bash
echo "========================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Upgrade to latest Kernel" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "========================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
dnf --enablerepo=elrepo-kernel install -y kernel-ml | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
