#!/usr/bin/env bash

##
## log "some msg info"
##
log()
{
    logMsg=$1
    dt=`date +"%Y-%m-%d %H:%M:%S"`
    echo "[$dt] $logMsg"
}

##
## createRunningLockFile hdfs://tencent-recom-hdp01:8020/camus/lock/action
##
createRunningLockFile()
{
    lockDir=$1
    lockFile="lock"
    testCmd="hadoop dfs -test -z $lockDir/$lockFile"
    eval $testCmd
    ret=$?
    if [ $ret -ne 1 ]
    then
        # lock file is exist, expect there is one old running job, log msg and exit
        lockExistWarnMsg="lock file is exist, expect there is one old job running!!! please check!!!\n lock path is: $lockDir/$lockFile"
        log "$lockExistWarnMsg"
        return 1
    fi

    createCmd="hadoop dfs -touchz $lockDir/$lockFile"
    eval $createCmd
    ret=$?
    if [ $ret -ne 0 ]
    then
        #create lock file failed, sleep and do retry
        createLockFailMsg="create lock file failed, i will retry again!!!"
        log "$createLockFailMsg"
        sleep 2m
        eval $createCmd
        ret=$?
        if [ $ret -ne 0 ]
        then
            createLockRetryFailMsg="retry create lock file failed !!! please check!!!"
            log "$createLockRetryFailMsg"
            return 1
        fi
    fi
    log "create lock file $lockDir/$lockFile success."
    return 0
}

deleteRunningLockFile()
{
    lockDir=$1
    lockFile="lock"
    deleteCmd="hadoop dfs -rm $lockDir/$lockFile"
    eval $deleteCmd
    ret=$?
    if [ $ret -ne 0 ]
    then
        #delete failed, do retry
        deleteLockFailMsg="delete lock file failed, i will do retry."
        log $deleteLockFailMsg
        sleep 1m
        eval $deleteCmd
        ret=$?
        if [ $ret -ne 0 ]
        then
            deleteLockRetryFailMsg="retry delete lock file failed !!! please check !!!"
            log "$deleteLockRetryFailMsg"
            return 1
        fi
    fi
    log "delete lock file $lockDir/$lockFile success."
    return 0
}

