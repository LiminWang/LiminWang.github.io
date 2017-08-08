#!/bin/bash
# This script run timeshifted streaming using ffmpeg with N hours offset

if [ "$#" -ne 3 ]; then
    echo "Usage: timeshift_ffmpeg.sh <path to directory with records> <offset in hours> <destination uri>"
    exit
fi

RECORDS_PATH=$1 # for example: /opt/storage/ch_2387
OFFSET_HOURS=$2 # in hours, for example: 10
URI=$3 # udp://@239.1.2.3:1234?pkt_size=1316
FFMPEG=`which ffmpeg`

function get_skip_seconds() {
    if [ "$#" -ne 1 ]; then
        LINE=1
    else
        LINE=$1
    fi

    # Get last modified file in path
    FILE=`ls -1t $RECORDS_PATH | sed -n ${LINE}p`
    if [ -z "${FILE}" ]; then
        echo "File with last record not found"
        exit
    fi

    DATE1=`date +%H`
    DATE2=`date -u +%H`
    OFFSET=`expr $DATE1 - $DATE2`


    # Get mtime of file (eq to last recorded time)
    FILE_MTIME=`stat -c %Y $RECORDS_PATH/$FILE`
    FILE_MTIME=`expr $OFFSET + $FILE_MTIME`
    # Get start time of record from filename
    START_TIME=`echo "$FILE" | cut -d "_" -f3 | cut -d "-" -f2`

    # Calculate how much seconds need to skip from beginning of file
    OFFSET_TIME=`expr $OFFSET_HOURS \* 3600`
    SKIP_SECONDS=`expr $FILE_MTIME - $START_TIME - $OFFSET_TIME`

    # Calculate offset error from now
    SKIP_SECONDS_FROM_NOW=`expr $FILE_MTIME - $START_TIME`
}

function run_ffmpeg() {
    CMD="$FFMPEG -re -ss $SKIP_SECONDS -i $RECORDS_PATH/$FILE -vcodec copy -acodec copy -f mpegts $URI"
    echo $CMD
    `$CMD`
}

get_skip_seconds 1
if [[ ! $SKIP_SECONDS -gt 0 ]]; then
    SAVED_SKIP_SECONDS_ERROR=$SKIP_SECONDS_FROM_NOW
    get_skip_seconds 2
    if [[ ! $SKIP_SECONDS -gt 0 ]]; then
        echo "Required offset has not recorded yet"
        exit
    else
        SKIP_SECONDS=`expr $SKIP_SECONDS + $SAVED_SKIP_SECONDS_ERROR`
        run_ffmpeg
    fi
else
    run_ffmpeg
fi

