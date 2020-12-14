#!/bin/bash
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
dnf install -y https://www.elrepo.org/elrepo-release-7.el7.elrepo.noarch.rpm
dnf --enablerepo=elrepo-kernel install -y kernel-ml
sudo awk -F\' '$1=="menuentry " {print i++ " : " $2}' /etc/grub2.cfg
sudo grub2-set-default 0 
sudo grub2-mkconfig -o /boot/grub2/grub.cfg
