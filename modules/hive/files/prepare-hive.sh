#!/usr/bin/env bash

. /etc/profile

export HDFS_USER=hdfs

su - $HDFS_USER -c "\
$HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /tmp /user/hive/warehouse;\
$HADOOP_PREFIX/bin/hdfs dfs -chmod g+w /tmp /user/hive/warehouse;\
$HADOOP_PREFIX/bin/hdfs dfs -chmod -R u+rwx,g+rwx,o+rx /user;\
$HADOOP_PREFIX/bin/hdfs dfs -chmod -R u+rwx,g+rwx,o+rx /tmp;\
"
