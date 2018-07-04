#!/bin/sh
set -x

umount -lf /home
mkdir /home.old

        if grep -Fq "home.old" /etc/fstab; then echo "exsit home.old"
        else
                sed -i -e 's/\/home/\/home.old/' /etc/fstab
        fi

mount -av

sed -i '/home/s/^#//g' /etc/auto.master
cp /remote.bin/auto.home /etc/
systemctl restart autofs

cp -ru /remote.bin/custom.sh /etc/profile.d/
