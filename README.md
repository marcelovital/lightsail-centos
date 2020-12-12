# lightsail-centosstream
Scripts to create an AWS Lightsail instance with CentOS Stream

These scripts are intended to take a default CentOS 7 image (tested on "7 1901-01") from AWS and tweak or upgrade them

# Usage:
- In AWS Lightsail, create an instance and copy-paste this script into the "Launch Script" box
- If you wish to follow the script's progress, ssh into the server after the instance is up and "tail -f /home/centos/centos-deploy.log"

**The full script is expected to run in about 15 minutes on a 1vCPU-1GbRAM ($5) instance.**

## Credits:

The migration from CentOS 7 to CentOS 8 is based in the guide from CentLinux at https://www.centlinux.com/2020/01/how-to-upgrade-centos-7-to-8-server.html

The switch from CentOS 8 to CentOS Stream 8 is based in the original instructions in https://www.centos.org/centos-stream/ 
