#!/bin/bash

# run one time every hour
# do not consider about one job may run beyond one hour now, i think it will not happen, but when it hapends, try with lock file

USAGE="bash start.sh properties_file"
if [ $# -ne 1 ]
then
    echo "[ERROR] $USAGE"
    exit 1
fi

properties_file=$1
echo "use properties file $properties_file"
hadoop jar camus-example-0.1.0-SNAPSHOT-shaded.jar com.linkedin.camus.etl.kafka.CamusJob -P $properties_file

