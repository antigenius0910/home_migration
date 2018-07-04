#!/bin/sh
set -x

echo 'nameserver 192.168.5.7' | cat - /etc/resolv.conf | tee /etc/resolv.conf
echo 'nameserver 192.168.5.6' | cat - /etc/resolv.conf | tee /etc/resolv.conf

ETH=$(ifconfig | grep -B1 192.168.5 | sed "s/:..*//" | sed "s/inet..*//" | sed "s/Link..*//")
echo $ETH

sed -i -e 's/DNS1=..*/DNS1=192.168.5.6/'  /etc/sysconfig/network-scripts/ifcfg-$ETH
sed -i -e 's/DNS2=..*/DNS2=192.168.5.7/'  /etc/sysconfig/network-scripts/ifcfg-$ETH


sed -i -e 's/use_fully_qualified_names = True/use_fully_qualified_names = False/' /etc/sssd/sssd.conf
sed -i -e 's/\/%u@%d/\/%u/' /etc/sssd/sssd.conf
#sed -i -e 's/.new\/home\/%u/\/%u/' /etc/sssd/sssd.conf

systemctl restart sssd
yum -y install autofs

mkdir /remote.bin
mount 192.168.5.30:/volume1/Shared_Home/bin /remote.bin
cp -rf /remote.bin/auto.master /etc/
cp -rf /remote.bin/auto.home.new /etc/

mkdir /home.new
systemctl enable autofs
systemctl start autofs
systemctl restart autofs
