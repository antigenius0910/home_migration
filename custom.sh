#!/bin/sh 
#script need to put under /etc/profile.d/ in order to apply system wide bash configration. 
f [ "$USER" == root ] ; then export HOME=/root
elif [ "$USER" == git ] ; then export HOME=/home.old/git; cd /home.old/git
elif [ "$USER" == gitliab ] ; then export HOME=/home.old/gitlab; cd /home.old/gitlab
elif [ "$USER" == oracle ] ; then export HOME=/home.old/oracle; cd /home.old/oracle
else

        if [ ! -d /home.new/home/$USER ]; then
        mkdir -p /home.new/home/$USER;
        fi

        export HOME=/home/$USER
        cd /home/$USER

                if [ ! -f /home/$USER/.bashrc ] ; then cp /etc/skel/.* /home/$USER/  &>/dev/null
                else
                        echo "User has .bachrc already." &>/dev/null
                fi
fi
