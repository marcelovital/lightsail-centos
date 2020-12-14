#!/bin/bash
yum install -y dnf
dnf remove -y yum yum-metadata-parser
rm -Rf /etc/yum
dnf update -y