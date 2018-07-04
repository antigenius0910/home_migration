#!/bin/sh
set -x

LOCAL_USERS=$(cat /etc/passwd | grep -i home | grep "^[^#;]"  | sed s"/:..*//")

for LOCAL_USER in $LOCAL_USERS
do

#        if [[ $LOCAL_USER =~ ^(git|gitlab|oracle)$ ]] ; then
#                echo "service account found! $LOCAL_USER. point home directory to /home.old/$LOCAL_USER"
#                sed -i -e "s/home\/$LOCAL_USER/home.old\/$LOCAL_USER/" /etc/passwd
#        else
                        #create new directory in /home.new/home/
                        if [ -d /home.new/home/$LOCAL_USER ] ; then echo "Directory exsit!"
                        else
                        mkdir /home.new/home/$LOCAL_USER
                        fi

                        #tar users' old home data in to /home.new/home/ with machine's hostname
                        cd /home
                        if [ -d /home.new/home/$LOCAL_USER/$LOCAL_USER@$HOSTNAME ] ; then echo "Directory exsit!"
                        else
                        #change this tarpiping line with "-C and --strip-components 1" for parallel processes
                        tar cf - $LOCAL_USER | (cd /home.new/home/$LOCAL_USER/; mkdir $LOCAL_USER@$HOSTNAME; sudo tar xf - -C $LOCAL_USER@$HOSTNAME --strip-components 1)
                        fi
#        fi
done
exit 0
