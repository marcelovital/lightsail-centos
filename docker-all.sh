#!/bin/bash
dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
sudo curl -L -o /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo
dnf -y --allowerasing install docker-ce docker-ce-cli containerd.io
systemctl enable docker