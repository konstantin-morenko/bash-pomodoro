#!/bin/bash

source timer-source.sh

WORK=0
SHORT=0
LONG=0
UNINT_WORK=0

TIME_WORK=20
TIME_SHORT=5
TIME_LONG=30

function save {
    echo -e "WORK=$WORK\nSHORT=$SHORT\nLONG=$LONG\nUNINT_WORK=$UNINT_WORK\n" > $DBASE_FILE
    echo -e "TIME_WORK=$TIME_WORK\nTIME_SHORT=$TIME_SHORT\nTIME_LONG=$TIME_LONG\n" >> $DBASE_FILE
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

ANSWER=""

while [[ $ANSWER != "q" ]]; do
    echo "--------------------"
    echo "w - work ($TIME_WORK) [$UNINT_WORK; $WORK]"
    echo "s - short break ($TIME_SHORT) [$SHORT]"
    echo "l - long break ($TIME_LONG) [$LONG]"
    echo "q - quit"
    read -p "? " ANSWER INTERVAL
    case $ANSWER in
	w) timer ${INTERVAL:-$TIME_WORK}
	   WORK=$(( $WORK+1 ))
	   UNINT_WORK=$(( $UNINT_WORK+1 ))
	   save ;;
	W) TIME_WORK=$INTERVAL
	   save ;;
	s) timer ${INTERVAL:-$TIME_SHORT} 0 "Time to work! (x)"
	   SHORT=$(( $SHORT+1 ))
	   save ;;
	S) TIME_SHORT=$INTERVAL
	   save ;;
	l) timer ${INTERVAL:-$TIME_LONG} 5 "Time to work! (x)"
	   LONG=$(( $LONG+1 ))
	   UNINT_WORK=0
	   save ;;
	L) TIME_LONG=$INTERVAL
	   save ;;
	q) save ;;
    esac
done
