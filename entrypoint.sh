#!/bin/sh
#
# docker-entrypoint for tailing and streaming logs files in a directory
echo "sleeping for a minute before starting"
sleep 60

if [ -n "${LOG_DIR}" ] ; then
   cd ${LOG_DIR}
   for i in $(ls) ; do
     if [[ -f $i ]] ; then
       echo "file to tail is $i "
       tail -f $i | sed "s/^/$i:/" &
     fi
   done
fi

echo "Tail processes ... "
ps -aef | grep tail

touch /tmp/a
tail -f /tmp/a
