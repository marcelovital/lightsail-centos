#!/bin/bash
echo "===== Init logfiles =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
cat /etc/centos-release | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy-started
uname -r | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy-started
chown centos:centos /home/centos/centos-deploy*
chmod 666 /home/centos/centos-deploy*

echo "===== Update and tweak CentOS 7 =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
yum update -y | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
yum install -y epel-release.noarch yum-utils rpmconf  | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
rm -f /etc/yum.repos.d/CentOS-Media.repo | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
yum update -y | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

echo "===== Replace YUM by DNF =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
yum install -y dnf | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
dnf remove -y yum yum-metadata-parser | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
rm -Rf /etc/yum | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
dnf update -y | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

echo "===== Upgrading CentOS 7 to CentOS 8 =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
dnf install -y http://mirror.centos.org/centos/8/BaseOS/x86_64/os/Packages/{centos-linux-release-8.3-1.2011.el8.noarch.rpm,centos-gpg-keys-8-2.el8.noarch.rpm,centos-linux-repos-8-2.el8.noarch.rpm} | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
dnf update -y epel-release | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
dnf remove -y bash-completion-extras | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
rpm -e `rpm -q kernel` | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
rpm -e --nodeps sysvinit-tools pycairo python3-3.6.8 python2-jmespath | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
dnf install -y kernel-core | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
dnf -y groupupdate "Core" "Minimal Install" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

echo "===== Install Tools =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
dnf install -y git vim wget ansible bash-completion setroubleshoot setools python3 python3-pip | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

# ===== UNCOMMENT THE LINES BELOW IF YOU WANT TO INSTALL PODMAN 1.6 =====
# echo "===== Update Kernel =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# dnf install -y podman buildah skopeo | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

# ===== UNCOMMENT THE LINES BELOW IF YOU WANT TO INSTALL PODMAN 2.2 =====
# echo "===== Install Podman 2.2 =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# dnf -y module disable container-tools | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# dnf -y install 'dnf-command(copr)' | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# dnf -y copr enable rhcontainerbot/container-selinux | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/CentOS_8/devel:kubic:libcontainers:stable.repo | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# dnf -y install podman buildah skopeo | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

# ===== UNCOMMENT THE LINES BELOW IF YOU WANT TO INSTALL DOCKER =====
# echo "===== Install Docker =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# dnf remove -y docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# sudo curl -L -o /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# dnf -y --allowerasing install docker-ce docker-ce-cli containerd.io | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# systemctl enable docker | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

# ===== UNCOMMENT THE LINES BELOW IF YOU WANT TO UPDATE THE KERNEL =====
# echo "===== Update Kernel =====" | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# dnf install -y https://www.elrepo.org/elrepo-release-8.el8.elrepo.noarch.rpm | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
# dnf --enablerepo=elrepo-kernel install -y kernel-ml | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

dnf -y update | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
dnf clean all | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log
mv /home/centos/centos-deploy-started /home/centos/centos-deploy-completed
cat /etc/centos-release | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy-completed
uname -r | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy-completed
systemctl reboot | gawk '{ print strftime("[%Y-%m-%d %H:%M:%S]"), $0 }' | tee -a /home/centos/centos-deploy.log

