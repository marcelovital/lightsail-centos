#!/bin/bash
echo "===== Init logfiles =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
cat /etc/centos-release | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy-started
uname -r | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy-started
chown centos:centos /home/centos/centos-deploy*
chmod 666 /home/centos/centos-deploy*

echo "===== Update and tweak CentOS 7 =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
sh<(https://raw.githubusercontent.com/marcelovital/lightsail-centos/main/basic-centos7.sh) | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

echo "===== Replace YUM by DNF =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
sh<(https://raw.githubusercontent.com/marcelovital/lightsail-centos/main/replace-yum-by-dnf.sh) | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

echo "===== Upgrading CentOS 7 to CentOS 8 =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
sh<(https://raw.githubusercontent.com/marcelovital/lightsail-centos/main/upgrade-centos7-to-centos8.sh) | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

echo "===== Switch CentOS 8 to CentOS Stream 8 =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log
sh<(https://raw.githubusercontent.com/marcelovital/lightsail-centos/main/upgrade-centos8-to-centosstream8.sh) | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' >> /home/centos/centos-deploy.log

echo "===== Install Tools =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
sh<(https://raw.githubusercontent.com/marcelovital/lightsail-centos/main/tools-centos8.sh) | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

# ===== UNCOMMENT THE LINES BELOW IF YOU WANT TO INSTALL PODMAN 1.6 =====
# echo "===== Update Kernel =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# sh<(https://raw.githubusercontent.com/marcelovital/lightsail-centos/main/podman1-all.sh) | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

# ===== UNCOMMENT THE LINES BELOW IF YOU WANT TO INSTALL PODMAN 2.2 =====
# echo "===== Update Kernel =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# sh<(https://raw.githubusercontent.com/marcelovital/lightsail-centos/main/podman2-centos8.sh) | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

# ===== UNCOMMENT THE LINES BELOW IF YOU WANT TO INSTALL DOCKER =====
# echo "===== Update Kernel =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# sh<(https://raw.githubusercontent.com/marcelovital/lightsail-centos/main/docker-all.sh) | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

# ===== UNCOMMENT THE LINES BELOW IF YOU WANT TO UPDATE THE KERNEL =====
# echo "===== Update Kernel =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# sh<(https://raw.githubusercontent.com/marcelovital/lightsail-centos/main/kernelupgrade-centos8.sh) | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

dnf -y update | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
dnf clean all | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
mv /home/centos/centos-deploy-started /home/centos/centos-deploy-completed
cat /etc/centos-release | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy-completed
uname -r | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy-completed
systemctl reboot | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log