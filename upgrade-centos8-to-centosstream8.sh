#!/bin/bash
dnf install -y centos-release-stream
dnf swap -y centos-{linux,stream}-repos
dnf -y --allowerasing distro-sync