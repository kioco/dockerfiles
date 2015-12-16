#!/bin/bash

echo "standaloneEnabled=false" >> conf/zoo.cfg
echo "dynamicConfigFile="${ZK_HOME}"/conf/zoo.cfg.dynamic" >> conf/zoo.cfg

if [[ -n "${ZK_XMX}" ]] && [[ -n "${ZK_XMS}" ]] ; then
  echo "export JVMFLAGS=\"-Xmx"${ZK_XMX}" -Xms"${ZK_XMS}"\"" > conf/java.env
fi

MYID=1
IP=$(hostname -i)

if [ -n "$ZK_ENABLE_CLUSTER" ]; then
  zk_servers=$(./bin/zkCli.sh -server zk:2181 get /zookeeper/config | grep ^server)
  MYID=$(expr $(echo ${zk_servers} | awk -F'server.' '{print $NF}' | cut -d'=' -f1) + 1)

  echo ${zk_servers} >> conf/zoo.cfg.dynamic
  sed -i 's/ /\n/g' conf/zoo.cfg.dynamic
  echo "server.$MYID=$IP:2888:3888:observer;2181" >> conf/zoo.cfg.dynamic
  bin/zkServer-initialize.sh --force --myid=${MYID}
  bin/zkServer.sh start
  bin/zkCli.sh -server zk:2181 reconfig -add "server.$MYID=$IP:2888:3888:participant;2181"
  bin/zkServer.sh stop
  while (netstat -nlp 2> /dev/null | awk '{print $4}' | grep -q ':2181$'); do sleep 1; done
else
  echo "server.$MYID=$IP:2888:3888;2181" >> conf/zoo.cfg.dynamic
  bin/zkServer-initialize.sh --force --myid=${MYID}
fi

bin/zkServer.sh start-foreground
