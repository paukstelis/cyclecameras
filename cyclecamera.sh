#!/bin/bash
#Define our port
PORT="8001"
#This is the camera device, passed from PHP script
CAMERA=$1

#Gets the PI of any running mjpg_streamer instance on the port
RUNNING="ss -ap 'sport = :$PORT' |  awk 'BEGIN {count=0;}  { if (\$2 == \"LISTEN\") count+=1} END { if (count>0) print \$7}' | grep -Po '(?<=pid=)[ A-Za-z0-9]*'"
PROCESS=`eval $RUNNING`

#No current stream on port, start it
if [ -z "$PROCESS" ]
then
    mjpg_streamer -b -i "input_uvc.so -d /dev/$CAMERA -y" -o "output_http.so -p $PORT"
    exit 0

#Check to see if running process is actually being watched. If not, kill the process and start new.
#If the stream is being actively watched for more than 10 minutes, kill it and start our new process
else
    RUNTIME=$(ps -o etimes= -p $PROCESS | xargs)
    PKILL="ss -ap 'sport = :$PORT' |  awk 'BEGIN {count=0;}  { if (\$2 == \"ESTAB\") count+=1} END { if (count==0) print \$7}' | grep -Po '(?<=pid=)[ A-Za-z0-9]*'"
    TOKILL=`eval $PKILL`
   
    if [ $RUNTIME -gt 6000 ]
    then
        TOKILL = $PROCESS
    fi

    if [ -z "$TOKILL" ]
    then
       exit 0
    else
        kill -INT $TOKILL
        while [ -n "$(ps -p $TOKILL -o pid=)" ]; do
            echo "Still running...."
        done
        mjpg_streamer -b -i "input_uvc.so -d /dev/$CAMERA -y" -o "output_http.so -p $PORT"
        exit 0
    fi
fi
