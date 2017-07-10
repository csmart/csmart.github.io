## Base kickstart for any CentOS based vm
##
## Boot a CentOS netinst image with following options:
##
## ks=https://csmart.github.io/ks/base.ks biosdevname=0 net.ifnames=0
##
## If you have a proxy, add this too:
## proxy=http://proxy:3128

# System authorization information
auth --enableshadow --passalgo=sha512

# Use network installation
url --url="http://mirror.internode.on.net/pub/centos/7/os/x86_64/"
repo --name="centos" --baseurl="http://mirror.internode.on.net/pub/centos/7/os/x86_64/"
repo --name="centos-updates" --baseurl="http://mirror.internode.on.net/pub/centos/7/updates/x86_64/"
repo --name="centos-extras" --baseurl="http://mirror.internode.on.net/pub/centos/7/extras/x86_64/"
repo --name="epel" --baseurl="http://mirror.internode.on.net/pub/epel/7/x86_64/"

# Network information
network --bootproto=dhcp --device=eth0 --noipv6 --activate

# Firewall configuration
firewall --enabled --service=ssh --remove-service=dhcpv6-client

# System services
services --enabled="chronyd,cloud-init,sshd,yum-cron" --disabled=""

# Use text install
text

# Don't run the Setup Agent on first boot
firstboot --disable

# Don't configure X
skipx

# Only use vda disk
ignoredisk --only-use=vda

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'

# System language
lang en_AU.UTF-8

# SELinux configuration
selinux --enforcing

# Root password
rootpw --iscrypted $6$/pFi171uL.KH.0tL$oJy8sQ6oGuczY1.C5Z0lQ8zqcHTQKlPIXX3Y1vX2mHVuEZvS110P7TWmaA9EKjHj1ZwzGOAO2QmbZjMfAP5zH/

# Create "Ansible Management User" and keys so that ansible works out of the box
user --name=amuser --groups=wheel --password=$6$u6XTTttLv706ixSA$BjTZfN.foS6mxauqnLkAlHVqSLQFhjapJH8pjnAGo373IyM5DEBz3niJ3xeK4zOVFoNmAQfCL5kHUe1QEX2Tj/ --iscrypted --gecos="Ansible Management User" --homedir="/home/amuser" --shell="/bin/bash" --uid=1000 --gid=1000
sshkey --username=amuser "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAmPlMAw6rRQKF6yylN7W2MRP5DWjJEv5ImJqn5d+jUqpJCg+waU0hWu+FczZq9hKRHhZOpLTr11PSAiIGjKQxgzckjrriU4r82UNZ0Xq5I58F3HnIp9VztTc2dapXICfen7Jqoli3OCUKVIuAW0QA2HH9WaHB8QVTf8vtythFMMSNIFh+pYBen3STkvn+3M7qD4GBQNUSImEOUYUZ1gkjENmCu1hHX2NXOEtTuF+tXjC/U6ZDd4z0bMspeMocO9CrVNwjpHheZocBOAbmKp1yZAlbDqheALm+CyHU7DeA4TnXnvO82OwD8nPTCz/NT43QuNtC5UJpghG5O0Xw7oQsBEg6txluBzDbdzhr9Mnpp7ac2dCg1D71FgeFZ1Z+4F9DK9a6syNp4u4V7E2C/X6IOvolVM40bkyCiSn2zKJu8OXk1AAgvDqQn9bwkEIh5nIZSxC/VE7S96Rf6wcUc8uUmJtQR2xJAhvpMCpl0zgydcM6BfIdETQZI9r3DfXNo5mYVcp0C7nnxdTucqjQmAOr3a2g4eGcgmN/wMAO9yp/Fad1fw9atbAN6/910eKbAqZKDSCbe0D8xawSFzdgVd+/bfuHgTJnIWWHYdEIFmapwIibHi5HeYyqGLlp+cp3Yk1I47OJS8U4o3Z/zOgXU03k3T8sV+IBgMT3/5+79jd9YQ== amuser@cloud.epic.test"

# System timezone
timezone UTC --isUtc

# System bootloader configuration
bootloader --md5pass="grub.pbkdf2.sha512.10000..F4CA507C07D0BD31BC779A08756826A6FD9DD97D43AC25E4B29A0933ABEA03F31FA1234792FF981F335BA91B0AB40E32643C5CC0DBD343ED6B1C61F1EE6AD559" --append="biosdevname=0 net.ifnames=0 ipv6.disable_ipv6=1 elevator=noop console=tty0 console=ttyS0,115200n8" --location=mbr --boot-drive=vda

# Partition clearing information
clearpart --all --initlabel --drives=vda

# Disk partitioning information
#autopart --type=lvm
part / --fstype="xfs" --ondisk=vda --size=2000 --label=root

reboot

%packages
@^minimal
@core
-alsa*
#bash-completion
-biosdevname
-btrfs-progs
chrony
cloud-init
cloud-utils-growpart
deltarpm
dracut-config-generic
dracut-norescue
epel-release
#git
-iprutils
-kexec-tools
-*firmware
-microcode*
#net-tools
#oddjob-mkhomedir
-plymouth*
-postfix
#rsync
#vim
#wget
yum-cron
%end

%post
# Add any core post commands here
%end

# Disable kdump
%addon com_redhat_kdump --disable --reserve-mb='auto'
%end

%anaconda
# Local password policy
pwpolicy root --minlen=6 --minquality=50 --notstrict --nochanges --notempty
pwpolicy user --minlen=6 --minquality=50 --notstrict --nochanges --notempty
pwpolicy luks --minlen=6 --minquality=50 --notstrict --nochanges --notempty
%end

