#!/bin/bash

n=0
until [ "$n" -ge 5 ]
do
   ${HADOOP_HOME}/bin/yarn --config ${HADOOP_CONF_DIR} resourcemanager && break  # substitute your command here
   n=$((n+1))
   sleep 10
done
