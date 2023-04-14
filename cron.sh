#!/usr/bin/env bash

cd $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

################################################################

DATE=$(TZ='Europe/Athens' date +"%Y%m%d_%H%M%S_%Z")
IFS='_' read -ra date_array <<< "$DATE"

DATE_YMD=${date_array[0]}
DATE_HMS=${date_array[1]}

################################################################

DIR_CACHE=./cache/${DATE_YMD:0:6}
PATH_LOG=$DIR_CACHE/${DATE_HMS:0:2}.log

################################################################

mkdir -p $DIR_CACHE/

################################################################

MSG=$(date +"%Y-%m-%dT%H:%M:%S.%3N%z")

################################################################

if [ ! -e "$PATH_LOG" ]           
then 
    echo $MSG > $PATH_LOG
else
    echo $MSG | cat - $PATH_LOG > temp && mv temp $PATH_LOG
fi

################################################################

date > README.md
