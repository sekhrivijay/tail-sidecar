# tail-sidecar

Simple and small bash script to tail all the files to stdout from a given log directory.
This conatiner can be used as a sidecar container to any other application container. When the directory (LOG_DIR) is provided though an environment variable , the script simply run as many tail process as there are files in that directory. 
The main reason for this to to stream all the logs onto ELK or AWS Cloudwatch or other log aggregation service via standard docker log driver 
