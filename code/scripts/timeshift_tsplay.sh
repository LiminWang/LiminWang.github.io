#!/bin/bash

# This script run timeshifted streaming using modified tsplay with N hours offset
# Modified tsplay with offsets support: https://github.com/Nikolay-Klimontov/tsplay-standalone.git

if [ "$#" -ne 3 ]; then
    echo "Usage: timeshift_tsplay.sh <channel id> <offset in hours> <destination uri>"
    exit
fi

CHANNEL_ID=$1 # 1
OFFSET_HOURS=$2 # in hours, for example: 10
URI=$3 # 239.1.2.3:1234
MICROPVR_HOST="127.0.0.1"
MICROPVR_PORT=4089

function parse_json()
{
    echo $1 | \
    sed -e 's/[{}]/''/g' | \
    sed -e 's/", "/'\",\"'/g' | \
    sed -e 's/" ,"/'\",\"'/g' | \
    sed -e 's/" , "/'\",\"'/g' | \
    sed -e 's/","/'\"---SEPERATOR---\"'/g' | \
    awk -F=':' -v RS='---SEPERATOR---' "\$1~/\"$2\"/ {print}" | \
    sed -e "s/\"$2\"://" | \
    tr -d "\n\t" | \
    sed -e 's/\\"/"/g' | \
    sed -e 's/\\\\/\\/g' | \
    sed -e 's/^[ \t]*//g' | \
    sed -e 's/^"//'  -e 's/"$//'
}

TIMESTAMP=`date -u +%s`
OFFSET_SECONDS=`expr $OFFSET_HOURS \* 3600`
OFFSET_TIMESTAMP=`expr $TIMESTAMP - $OFFSET_SECONDS`
REQ="{\"jsonrpc\":\"2.0\",\"method\":\"get_file_offset\",\"id\":\"0\",\"params\":{\"channel_id\":$CHANNEL_ID,\"timestamp\":$OFFSET_TIMESTAMP}}"
S=`echo $REQ | nc $MICROPVR_HOST $MICROPVR_PORT`
FILE=`parse_json $S file`
OFFSET=`parse_json $S offset`
TSPLAY="/usr/local/bin/tsplay_standalone"

CMD="$TSPLAY $FILE -offset $OFFSET $URI"
echo $CMD
`$CMD`
