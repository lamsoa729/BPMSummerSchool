#!/bin/bash

printf "What happens when tasks lack stdout and stderr redirections?\n"

[[ -e disBatch ]] || { printf "Did you run example 1?\n" ; exit ; }

PYTHONPATH=$(readlink -f disBatch):${PYTHONPATH}

DIR=example_3_files
rm -rf ${DIR}
mkdir ${DIR}
cd ${DIR}

reps=13
for x in $(seq 1 ${reps})
do
    printf "../square ${x}\n"
done > Tasks
printf "\nTasks:\n"
cat Tasks

echo "../disBatch/disBatch -s localhost:16 Tasks" > disBatch_cmd
printf "Running:\n\t$(cat disBatch_cmd)\n"
( . disBatch_cmd ; sleep 3 ; kill -SIGTERM $$ ) &

while [ ! -e *_status.txt ]
do
    sleep 1
done
status=(*_status.txt)
printf "\nTailing status file ${status}:\n"
trap 'kill ${tail_pid}' SIGTERM
tail -f ${status} &
tail_pid=$!
wait ${tail_pid} 2> /dev/null

awk -F'\t' '$9 != "Start" {t0=(t0 > 0 && t0 < $9)?t0:$9;t1=$10; tasks = tasks + 1}END{print "\nTasks", tasks, "; Elapsed", t1-t0}' *_status.txt
