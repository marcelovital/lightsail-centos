#!/bin/bash
rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
dnf install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm
dnf --enablerepo=elrepo-kernel install -y kernel-ml
