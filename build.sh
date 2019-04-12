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
    echo -e "#!/bin/bash\n\nexport HADOOP_HOME=/cluster/software/hadoop\nexport HADOOP_USER_NAME=work\nbash start.sh camus_${topic}.properties /camus/lock/action" > "$dir/start_${topic}.sh" 
    echo -e "#!/bin/bash\n\nexport HADOOP_HOME=/cluster/software/hadoop\nexport HADOOP_USER_NAME=work\nbash start.sh camus_${topic}_init.properties /camus/lock/action" > "$dir/start_init_${topic}.sh" 
    chmod +x "$dir/start_${topic}.sh"
    chmod +x "$dir/start_init_${topic}.sh"
    cp "config/camus_${topic}.properties" $dir
    cp "config/camus_${topic}_init.properties" $dir
    cp "azkaban/camus_${topic}.job" $dir
    cd $dir
    zip "../${topic}.zip" *
    cd ../..
done

