#!/bin/bash

printf "Example running more tasks, using the monitor and showing how to add resources to a disBatch run.\n"

[[ -e disBatch ]] || { printf "Did you run example 1?\n" ; exit ; }

PYTHONPATH=$(readlink -f disBatch):${PYTHONPATH}

DIR=example_6_files
rm -rf ${DIR}
mkdir ${DIR}
cd ${DIR}

reps=200
printf '#DISBATCH REPEAT '${reps}' start 1 x=${DISBATCH_REPEAT_INDEX} ; ../square ${x} > ${x}.out 2> ${x}.err' > Tasks
printf "\nTasks (note the increase):\n"
cat Tasks

echo "../disBatch/disBatch --use-address=localhost:0 -s localhost:4 Tasks" > disBatch_cmd
printf "\nRunning:\n\t$(cat disBatch_cmd)\n"
. disBatch_cmd &

while [ ! -e *dbUtil.sh ]
do
    sleep 1
done
dbu=(*dbUtil.sh)
echo "./${dbu} -s localhost:20" > add_resources_cmd
echo "./${dbu} --mon" > monitor_cmd
printf "\nUsing ${dbu} to monitor the run (\"q\" to exit):\n\n\t$(cat monitor_cmd)\n\nAfter a 30 s delay, will add more resources to run tasks:\n\n\t$(cat add_resources_cmd)\n"
(sleep 30 ; . add_resources_cmd) &
sleep 20
. monitor_cmd

awk -F'\t' '$9 != "Start" {t0=(t0 > 0 && t0 < $9)?t0:$9;t1=$10; tasks = tasks + 1}END{print "\nTasks", tasks, "; Elapsed", t1-t0}' *_status.txt
