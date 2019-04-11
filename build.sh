#!/bin/bash

#mvn clean package -Dmaven.test.skip=true

[ -d release ] && { rm -rf release; }
mkdir release

topics=(action recall access)

for topic in ${topics[@]}
do
    dir="release/$topic"
    mkdir $dir
    cp camus-example/target/camus-example-0.1.0-SNAPSHOT-shaded.jar $dir
    cp bin/functions.sh $dir
    cp bin/start.sh $dir
    cp "bin/start_${topic}.sh" $dir
    cp config/* $dir
    cd $dir
    zip "../${topic}.zip" *
    cd ../..
done

