#!/bin/sh
set -x

LOCAL_USERS=$(cat /etc/passwd | grep -i home | grep "^[^#;]"  | sed s"/:..*//")


for LOCAL_USER in $LOCAL_USERS
do
        if [[ $LOCAL_USER =~ ^(git|gitlab|oracle)$ ]] ; then
        #echo "service account found! $LOCAL_USER. don't rsync directories"
        echo "service account found! $LOCAL_USER. point home directory to /home.old/$LOCAL_USER"
        sed -i -e "s/home\/$LOCAL_USER/home.old\/$LOCAL_USER/" /etc/passwd

        else

                #do final rsync for all user
                rsync -avz /home/$LOCAL_USER/ /home.new/home/$LOCAL_USER/$LOCAL_USER@$HOSTNAME/

AD_USER_UID=$(id $LOCAL_USER@sparkcognition.com | sed s'/uid=//' | sed s'/(..*//')
AD_USER_GID=$(id admin@sparkcognition.com | sed s'/uid..*gid=//' | sed s'/(..*//')

LOCAL_USER_UID=$(id $LOCAL_USER | sed s'/uid=//' | sed s'/(..*//')
LOCAL_USER_GID=$(id $LOCAL_USER | sed s'/uid..*gid=//' | sed s'/(..*//')

                cd /home.new/home/$LOCAL_USER

                #if no AD user UID then keep orignial else apply AD UID and GID  
                if [[ -z "$AD_USER_UID" ]]; then
                        echo "No AD account!"
                        chown -R $LOCAL_USER_UID:$LOCAL_USER_GID $LOCAL_USER@$HOSTNAME
                        cd /home.new/home/
                        chown $LOCAL_USER_UID:$LOCAL_USER_GID $LOCAL_USER; chmod 700 $LOCAL_USER
                #cut off local users who has no record in AD
                        sed -e "/$LOCAL_USER/ s/^#*/#/" -i /etc/passwd
                        sed -e "/$LOCAL_USER/ s/^#*/#/" -i /etc/shadow
                        sed -e "/$LOCAL_USER/ s/^#*/#/" -i /etc/group

                else
                        echo 'AD account exsit!'        
                        chown -R $AD_USER_UID:$AD_USER_GID $LOCAL_USER@$HOSTNAME
                        cd /home.new/home/
                        chown $AD_USER_UID:$AD_USER_GID $LOCAL_USER; chmod 700 $LOCAL_USER
                #cut off user from local to AD
                        sed -e "/$LOCAL_USER/ s/^#*/#/" -i /etc/passwd
                        sed -e "/$LOCAL_USER/ s/^#*/#/" -i /etc/shadow
                        sed -e "/$LOCAL_USER/ s/^#*/#/" -i /etc/group

                fi
        fi
done

#echo 'then for system'
#echo '!!!!!!!!!!!!!!!'

exit 0
