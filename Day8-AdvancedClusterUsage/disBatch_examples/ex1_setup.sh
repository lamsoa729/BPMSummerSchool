#!/bin/bash

printf "Initial setup and testing\n"

if [[ -e disBatch ]]
then
    printf "Using existing clone.\n"
else
    cmd="git clone --recursive https://github.com/flatironinstitute/disBatch.git"
    printf "Cloning disBatch:\n\t${cmd}\n"
    ${cmd}
    [[ -e disBatch ]] || { printf "git clone failed?\n" ; exit ; }
fi

cat > square <<'EOF'
#!/bin/bash

x=$1
if [ $x != 7 ]
then
	sleep 5
	echo "$x^2 = $(( x * x ))"
else
	echo "Buggy!" >&2
	exit 123
fi
EOF
chmod +x square

export PYTHONPATH=$(readlink -f disBatch):${PYTHONPATH}

DIR=example_1_files
rm -rf ${DIR}
mkdir ${DIR}
cd ${DIR}

reps=13
for x in $(seq 1 ${reps})
do
    printf "../square ${x} > ${x}.out 2> ${x}.err\n"
done > Tasks

printf "\nTasks:\n"
cat Tasks

echo "../disBatch/disBatch --status-header --use-address=localhost:0 -s localhost:2 Tasks" > disBatch_cmd
printf "\nRunning:\n\t$(cat disBatch_cmd)\n"
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

awk -F'\t' '$9 != "Start" {t0=(t0 > 0 && t0 < $9)?t0:$9;t1=$10; tasks = tasks + 1}END{print "\nTasks", tasks, "; Elapsed", t1-t0}' *_status.txt
