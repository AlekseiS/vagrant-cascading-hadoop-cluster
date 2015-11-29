#!/usr/bin/env bash

. /etc/profile

set +x

export DRILL_USER=vagrant

for slave in $(cat $DRILL_HOME/conf/slaves); do
  ssh $slave "su - $DRILL_USER -c \"drillbit.sh start\"";
done
