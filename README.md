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

LOG_DIR is passed as an environment variable and all the files in that directory will be streamed to AWS Cloudwatch log. This image shouldl run only when the main application image is up and running. Otherwise the logs files would not be generated yet. The script just runs tail on existing logs files only. So the log files needs to be there first .
