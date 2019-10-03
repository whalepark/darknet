#!/bin/bash

function run_model {
trap "echo SIGINT is issued." SIGINT
trap "echo SIGTERM is issued." SIGTERM
trap "echo SIGHUP is issued." SIGHUP
trap "echo SIGQUIT is issued." SIGQUIT
trap "echo SIGTTIN is issued." SIGTTIN


   # elapsed_time=$(nohup ./darknet detect cfg/yolov3.cfg yolov3.weights data/dog.jpg < /dev/null 2> /dev/null | grep seconds)
     elapsed_time=$(./darknet detect cfg/yolov3.cfg yolov3.weights data/dog.jpg < /dev/null | grep seconds)
    FS=' ' read -r -a array <<< $elapsed_time
    log=$1','$2','${array[3]}
    echo $log
    echo $log >> 'log/'$4'_'$1'_'$2'.txt'
}
function run_model3 {
    elapsed_time=$((./darknet detect cfg/yolov3.cfg yolov3.weights data/dog.jpg 2> /dev/null) | grep seconds)
    FS=' ' read -r -a array <<< $elapsed_time
    log=$1','$2','${array[3]}
    echo $log
    echo $log >> "log/"$4"_"$1"_"$2".txt"
}
cd ~/darknet
mkdir -p log
#for k in $(seq 1 3); do
#            run_model2 2 $(echo "test") "linearinc" &
#        done;
#        wait
for i in $(seq 1 20); do # i=numofcurrent..
    num_of_iteration=$(echo "(20+$i-1)/$i" | bc) # floor
    for j in $(seq 1 $num_of_iteration); do
        for k in $(seq 1 $i); do
            run_model $i $(($k+$(($(($j-1))*$i)))) "linearinc" &
        done
        wait
    done
done
for i in 1 2 4 8 16; do
    num_of_iteration=$(echo "(20+$i-1)/$i" | bc) # floor
    for j in $(seq 1 $num_of_iteration); do
        for k in $(seq 1 $i); do
            run_model $i $(($k+$(($(($j-1))*$i)))) "expinc" &
        done
        wait
    done
done

