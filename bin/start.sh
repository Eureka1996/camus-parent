#!/bin/bash

# run one time every hour
# do not consider about one job may run beyond one hour now, i think it will not happen, but when it hapends, try with lock file

USAGE="bash start.sh properties_file lock_dir"
if [ $# -ne 2 ]
then
    echo "[ERROR] $USAGE"
    exit 1
fi

properties_file=$1
lock_dir=$2
echo "use properties file $properties_file, lock dir $lock_dir"

. functions.sh

createRunningLockFile $lock_dir
ret=$?
if [ $ret -ne 0 ]
then
    echo "createRunningLockFile $lock_dir error !!!"
    exit $ret
fi
hadoop jar camus-example-0.1.0-SNAPSHOT-shaded.jar com.linkedin.camus.etl.kafka.CamusJob -P $properties_file
deleteRunningLockFile $lock_dir
ret=$?
if [ $ret -ne 0 ]
then
    echo "deleteRunningLockFile $lock_dir error !!!"
fi

