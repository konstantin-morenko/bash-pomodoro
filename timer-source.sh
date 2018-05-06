function notify {
    MESSAGE=$1
    EXPIRE=$2
    NOTIFIER="notify-send"
    case $EXPIRE in
	pin)
	    $NOTIFIER "(`date +%H:%M`) $MESSAGE (x)" --expire-time=0 ;;
	*)
	    $NOTIFIER "$MESSAGE" ;;
    esac
    return
}

function message {
    MESSAGE=$1
    echo -ne "\r                    " # clear string
    echo -ne "\r$MESSAGE"
    return
}

function output_left {
    LEFT=$1
    NOTIF_INTERVAL=$2
    MESSAGE="$LEFT minutes left"
    message "$MESSAGE"
    if [ $NOTIF_INTERVAL != 0 ] && [ $(($LEFT % $NOTIF_INTERVAL)) == 0 ]; then
	notify "$MESSAGE"
    fi
    return
}

function timer {
    INTERVAL=$1
    NOTIF_INTERVAL=${2:-5}
    FINAL_MESSAGE=${3:-"Take a break!"}
    notify "Started!"
    for LEFT in $(seq $INTERVAL -1 1); do
	output_left $LEFT $NOTIF_INTERVAL
	sleep 60
    done
    message "Total $INTERVAL minutes"
    echo ""
    notify "$FINAL_MESSAGE" pin
    return
}
