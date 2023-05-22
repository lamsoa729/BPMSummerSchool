#!/bin/bash

printf "Resume an interrupted run.\n"

[[ -e disBatch ]] || { printf "Did you run example 1?\n" ; exit ; }

PYTHONPATH=$(readlink -f disBatch):${PYTHONPATH}

DIR=example_5_files
rm -rf ${DIR}
mkdir ${DIR}
cd ${DIR}

reps=13
printf '#DISBATCH REPEAT '${reps}' start 1 x=${DISBATCH_REPEAT_INDEX} ; ../square ${x} > ${x}.out 2> ${x}.err\n' > Tasks

echo "../disBatch/disBatch -s localhost:4 Tasks" > disBatch_cmd
printf "\nRunning:\n\t$(cat disBatch_cmd)\n"
( { . disBatch_cmd & db=$! ; sleep 11 ; kill -SIGTERM ${db} ; wait ${db} 2> /dev/null ; } ; sleep 3 ; kill -SIGTERM $$ ) &

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
tail_pid="NOPID"
printf "\nFirst disBatch was killed.\n"
awk -F'\t' '$9 != "Start" {t0=(t0 > 0 && t0 < $9)?t0:$9;t1=$10; tasks = tasks + 1}END{print "\nInterrupted: Tasks", tasks, "; Elapsed", t1-t0}' ${status}

RESUME_DIR="resume"
rm -rf ${RESUME_DIR}
mkdir ${RESUME_DIR}

echo "../disBatch/disBatch -s localhost:6 Tasks -p ${RESUME_DIR} -r ${status}" > disBatch_resume_cmd
printf "\nNow running resume:\n\t$(cat disBatch_resume_cmd)\n"
( . disBatch_resume_cmd ; sleep 3 ; kill -SIGTERM $$ ) &
while [ ! -e ${RESUME_DIR}/*_status.txt ]
do
    sleep 1
done
resume_status=(${RESUME_DIR}/*_status.txt)
printf "\nTailing status file ${resume_status}:\n"
tail -f ${resume_status} &
tail_pid=$!
wait ${tail_pid} 2> /dev/null

awk -F'\t' '!($9 == "Start" || $1 ~/S/){t0=(t0 > 0 && t0 < $9)?t0:$9;t1=$10; tasks = tasks + 1}END{print "\nResumed: Tasks", tasks, "; Elapsed", t1-t0}' ${resume_status}

printf "\nOutputs:\n"
for f in *[0-9].out
do
    printf "${f}:\t"
    [ -s $f ] && cat $f || printf "\n"
done

printf "\nErrors:\n"
for f in *[0-9].err
do
    printf "${f}:\t"
    [ -s $f ] && cat $f || printf "\n"
done
