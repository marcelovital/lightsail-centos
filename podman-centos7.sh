#!/bin/bash
echo "===========================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "Install Podman (Kubic Repo)" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
echo "===========================" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_7/devel:kubic:libcontainers:stable.repo
yum -y install podman buildah skopeo
