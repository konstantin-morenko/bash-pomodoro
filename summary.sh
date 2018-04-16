#!/bin/bash

SUM_WORK=0
SUM_SHORT=0
SUM_LONG=0

function load_source {
    BEGIN_DATE=$1
    END_DATE=$2
    CURRENT=$BEGIN_DATE
    while [ $CURRENT != $END_DATE ]; do
	FILENAME=$CURRENT.pom
	source $FILENAME
	SUM_WORK=$(( $SUM_WORK + $WORK ))
	SUM_SHORT=$(( $SUM_SHORT + $SHORT ))
	SUM_LONG=$(( $SUM_LONG + $LONG ))
	CURRENT=`date --date="$CURRENT +1 day" +%F`
    done
    return
}

function print {
    echo "Work: $SUM_WORK"
    echo "Short: $SUM_SHORT"
    echo "Long: $SUM_LONG"
    return
}

load_source $1 $2
print
