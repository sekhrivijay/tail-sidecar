# tail-sidecar

Simple and small bash script to tail all the files to stdout from a given log directory.
This container can be used as a sidecar container to any other application container. When the directory (LOG_DIR) is provided though an environment variable , the script simply run as many tail process as there are files in that directory. 
The main reason for this is to stream all the logs onto ELK or AWS Cloudwatch or other log aggregation service via standard docker log driver 

Example of running the docker image and stream all the files to AWS Cloudwatch logs 

    docker run \
    -d \
    --name tail \
    --log-driver=awslogs \
    --log-opt awslogs-region=${region} \
    --log-opt awslogs-group=${logGroup} \
    --log-opt awslogs-stream=${logStream} \
    -v ${logDir}/:/logs \
    -e "LOG_DIR=/logs" \
     sekhrivijay/tail-sidecar

LOG_DIR is passed as an environment variable and all the files in that directory will be streamed to AWS Cloudwatch log. This image should run only when the main application image is up and running. Otherwise the logs files would not be generated yet. The script just runs tail on existing logs files only. So the log files needs to be there first .

This way not only stdout, stderr of the docker conatiner is streamed , but all the file including GC logs , VM logs are streamed into AWS Cloudwatch service as long as those files exist and they are in one single directory.

Here is an example of running the main appplication container and sidecar

One 1st console 

logDir=/tmp/abc
mkdir ${logDir}
cd ${logDir}
touch a b c
docker run -it -v ${logDir}:/tmp/test ubuntu bash
ls /tmp/test/
  a  b  c

On a second console run the sidecar and it will start tailing all the files a b and c in this case

docker run --name tail -v /tmp/abc/:/logs  -e "LOG_DIR=/logs" sekhrivijay/tail-sidecar
file to tail is a
file to tail is b
file to tail is c
Tail processes ...
    6 root       0:00 tail -f a
    8 root       0:00 tail -f b
   10 root       0:00 tail -f c
   13 root       0:00 grep tail



Back on the first console start putting data on the files a b and c and watch them streamed out on the second console
echo "This is for a " >> /tmp/test/a
echo "This is for b " >> /tmp/test/b
echo "This is for c " >> /tmp/test/c


Notice only after the flush happens the same messages will appear on the second console 
a:This is for a 
c:This is for c
b:This is for b


