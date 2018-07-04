---


**On single server sync current /home/USERNAME to shared home directory /home.new/home/**

1. mkdir /remote.bin
2. mount 192.168.5.30:/volume1/Shared_Home/bin /remote.bin
3. /remote.bin/apply_AD_change.sh  
4. /remote.bin/transfer_user_home.sh &
5. disown

**When no one is using server disable all ssh access but root, then go next step**


* /remote.bin/final_rsync.sh

**when final_rsync finished. cut over local home to remote shared home by using cut_over.sh**


* /remote.bin/cut_over.sh

**in case anything happen after cut over. We can roll back shared home back to local home using roll_back.sh**


* /remote.bin/roll_back.sh


---
