#!/bin/bash
yum update -y
yum install -y epel-release.noarch yum-utils rpmconf 
rm -f /etc/yum.repos.d/CentOS-Media.repo
yum update -y

yum install -y dnf
dnf remove -y yum yum-metadata-parser
rm -Rf /etc/yum
dnf update -y

dnf install -y git vim wget ansible bash-completion bash-completion-extras setroubleshoot setools
dnf clean all

