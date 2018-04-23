#!/bin/bash

source timer-source.sh

WORK_NUM=0
SHORT_NUM=0
LONG_NUM=0
WORK_NUM_UNINT=0

WORK_INTERVAL=20
SHORT_INTERVAL=5
LONG_INTERVAL=30

WORK_TIME=0
SHORT_TIME=0
LONG_TIME=0

function save {
    echo -e "WORK_NUM=$WORK_NUM\nSHORT_NUM=$SHORT_NUM\nLONG_NUM=$LONG_NUM\nWORK_NUM_UNINT=$WORK_NUM_UNINT\n" > $DBASE_FILE
    echo -e "WORK_INTERVAL=$WORK_INTERVAL\nSHORT_INTERVAL=$SHORT_INTERVAL\nLONG_INTERVAL=$LONG_INTERVAL\n" >> $DBASE_FILE
    echo -e "WORK_TIME=$WORK_TIME\nSHORT_TIME=$SHORT_TIME\nLONG_TIME=$LONG_TIME\n" >> $DBASE_FILE
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
    printf "%-1s - %-12s {%2d} [%2d, %2d] (%3d)\n" "w" "work"  $WORK_INTERVAL $WORK_NUM_UNINT $WORK_NUM $WORK_TIME
    printf "%-1s - %-12s {%2d}     [%2d] (%3d)\n" "s" "short break" $SHORT_INTERVAL $SHORT_NUM $SHORT_TIME
    printf "%-1s - %-12s {%2d}     [%2d] (%3d)\n" "l" "long break" $LONG_INTERVAL $LONG_NUM $LONG_TIME
    echo "q - quit"
    read -p "? " ANSWER INTERVAL
    case $ANSWER in
	[w]) timer ${INTERVAL:=$WORK_INTERVAL} 5 "[$INTERVAL mins] Time to break!"
	   WORK_NUM=$(( $WORK_NUM+1 ))
	   WORK_NUM_UNINT=$(( $WORK_NUM_UNINT+1 ))
	   WORK_TIME=$(( $WORK_TIME+$INTERVAL ))
	   save ;;
	W) WORK_INTERVAL=$INTERVAL
	   save ;;
	[s]) timer ${INTERVAL:=$SHORT_INTERVAL} 0 "[$INTERVAL mins] Time to work!"
	   SHORT_NUM=$(( $SHORT_NUM+1 ))
	   SHORT_TIME=$(( $SHORT_TIME+$INTERVAL ))
	   save ;;
	S) SHORT_INTERVAL=$INTERVAL
	   save ;;
	[l]) timer ${INTERVAL:=$LONG_INTERVAL} 5 "[$INTERVAL mins] Time to work!"
	   LONG_NUM=$(( $LONG_NUM+1 ))
	   WORK_NUM_UNINT=0
	   LONG_TIME=$(( $LONG_TIME+$INTERVAL ))
	   save ;;
	L) LONG_INTERVAL=$INTERVAL
	   save ;;
	q) save ;;
    esac
done
