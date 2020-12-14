#!/bin/bash
yum update -y
yum install -y epel-release.noarch yum-utils rpmconf 
rm -f /etc/yum.repos.d/CentOS-Media.repo
yum update -y

dnf clean all

