#!/usr/bin/env bash

cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

################################################################

DATE=$(TZ='Europe/Athens' date +"%Y%m%d_%H%M%S_%Z")
IFS='_' read -ra date_array <<< "$DATE"

DATE_YMD=${date_array[0]}
DATE_HMS=${date_array[1]}

################################################################

DIR_CACHE=./cache/${DATE_YMD:0:6}
PATH_LOG=$DIR_CACHE/${DATE_YMD:6:2}_${DATE_HMS:0:2}.log

################################################################

mkdir -p $DIR_CACHE/

################################################################

T1=$(date +"%Y-%m-%dT%H:%M:%S.%3N%z")

METRIC_PING=$(ping -c 4 8.8.8.8 | tail -1| awk -F '/' '{print $5}')

#echo $METRIC_PING

T2=$(date +"%Y-%m-%dT%H:%M:%S.%3N%z")

HOST_NAME=$(hostname)

POWER_ONLINE=$(cat /sys/class/power_supply/AC/online)

if [[ -f /sys/class/power_supply/BAT0/status ]]; then
	POWER_STATUS=$(cat /sys/class/power_supply/BAT0/status)
	POWER_CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
else
	POWER_STATUS=$(cat /sys/class/power_supply/BAT1/status)
	POWER_CAPACITY=$(cat /sys/class/power_supply/BAT1/capacity)
fi

#BAT_ID=$(upower -e | grep BAT)

#POWER_STATUS=$(upower -i $BAT_ID|grep state| cut -d ':' -f2 | xargs)
#POWER_PERCENTAGE=$(upower -i $BAT_ID|grep percentage| grep -o "[0-9]*")

MSG=$T1,$T2,$METRIC_PING,$HOST_NAME,$POWER_ONLINE,$POWER_STATUS,$POWER_CAPACITY

#echo $MSG;exit

################################################################

git pull --no-edit

################################################################

if [ ! -e "$PATH_LOG" ]           
then 
    echo $MSG > $PATH_LOG
else
    echo $MSG | cat - $PATH_LOG > temp && mv temp $PATH_LOG
fi

################################################################

date > README.md
echo "# JAM" >> README.md
echo "<a href='$PATH_LOG'>$PATH_LOG</a>" >> README.md

################################################################

date -u +"%Y-%m-%dT%H:%M:%S" > latest.txt

################################################################

rm -f _*

################################################################

#GIT_SSH_COMMAND='ssh -i .ssh/id_ed25519_github_hb -o IdentitiesOnly=yes' git clone git@github.com:ziqbal/hb.git

export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_ed25519_github_hb -o IdentitiesOnly=yes'

git add .
git commit -m "auto" .
git push

################################################################
