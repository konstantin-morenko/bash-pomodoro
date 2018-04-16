#!/bin/bash

source timer-source.sh

WORK=0
SHORT=0
LONG=0

function save {
    echo -e "WORK=$WORK\nSHORT=$SHORT\nLONG=$LONG\n" > $DBASE_FILE
}

function load {
    DBASE_FILE=$1
    if [ -a $DBASE_FILE ]; then
	source $DBASE_FILE
    else
	save
    fi
    return
}

load `date +%F`.pom

echo "Pomodoro timer!"
echo "==============="

TIME_WORK=20
TIME_SHORT=5
TIME_LONG=30

ANSWER=""
UNINT_WORK=0
while [[ $ANSWER != "q" ]]; do
    echo "--------------------"
    echo "w - work ($TIME_WORK) [$UNINT_WORK; $WORK]"
    echo "s - short break ($TIME_SHORT) [$SHORT]"
    echo "l - long break ($TIME_LONG) [$LONG]"
    echo "q - quit"
    read -p "? " ANSWER INTERVAL
    case $ANSWER in
	w*) timer ${INTERVAL:-$TIME_WORK}
	    $(( WORK+=1 ))
	    $(( UNINT_WORK+=1 ))
	    save ;;
	s*) timer ${INTERVAL:-$TIME_SHORT} 0 "Time to work! (x)"
	    $(( SHORT+=1 ))
	    save ;;
	l*) timer ${INTERVAL:-$TIME_LONG} 5 "Time to work! (x)"
	    $(( LONG+=1 ))
	    UNINT_WORK=0
	    save ;;
	q*) save ;;
    esac
done
