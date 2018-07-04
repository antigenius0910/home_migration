#!/bin/sh
set -x

umount -lf /home/*
sed -e "/home/ s/^#*/#/" -i /etc/auto.master
systemctl restart autofs

umount -lf /home.old
#mkdir /home.old

        if grep -Fq "home.old" /etc/fstab; then sed -i -e 's/\/home.old/\/home/' /etc/fstab
        fi

mount -av

sed -i -e 's/#//g' /etc/passwd
sed -i -e 's/#//g' /etc/group
sed -i -e 's/#//g' /etc/shadow
rm -rf /etc/profile.d/custom.sh
