#!/usr/bin/env bash
set -e

JVM_ALL_OPTS="-server -Djava.awt.headless=true -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/"

if [ -z "${JVM_XMX}" ]; then JVM_XMX="512m"; fi
if [ -z "${JVM_XMS}" ]; then JVM_XMS="512m"; fi
if [ -z "${JVM_DIRECT_MEMORY}" ]; then JVM_DIRECT_MEMORY="512m"; fi
JVM_ALL_OPTS+=" -Xmx${JVM_XMX} -Xms${JVM_XMS} -XX:MaxDirectMemorySize=${JVM_DIRECT_MEMORY}"

CPU_CORES=$(getconf _NPROCESSORS_ONLN)
CPU_CORES_QUARTER=$(quarter=$(echo ${CPU_CORES} / 4 | bc); if [ ${quarter} -eq 0 ]; then echo "1"; else echo ${quarter}; fi)
if [ -z "${JVM_GC_OPTS}" ]; then JVM_GC_OPTS="-XX:+UseG1GC -XX:ParallelGCThreads=${CPU_CORES} -XX:ConcGCThreads=${CPU_CORES_QUARTER} -XX:+DisableExplicitGC"; fi
JVM_ALL_OPTS+=" ${JVM_GC_OPTS}"

JVM_DEBUG_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -Xloggc:/tmp/java-gc.log"
if [ "$JVM_ENABLE_DEBUG" = true ]; then JVM_ALL_OPTS+=" ${JVM_DEBUG_OPTS}"; fi

if [ -z "${JMX_HOST}" ]; then JMX_HOST=$(hostname -i | awk '{print $1}'); fi
if [ -z "${JMX_PORT}" ]; then JMX_PORT=9999; fi
JVM_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname=${JMX_HOST} -Dcom.sun.management.jmxremote.port=${JMX_PORT} -Dcom.sun.management.jmxremote.rmi.port=${JMX_PORT}"
if [ "$JVM_ENABLE_JMX" = true ]; then JVM_ALL_OPTS+=" ${JVM_JMX_OPTS}"; fi

if [ "${JVM_OPTS}" ]; then JVM_ALL_OPTS+=" ${JVM_OPTS}"; fi

echo "[java-wrapper] Executing: java ${JVM_ALL_OPTS} $@"
java ${JVM_ALL_OPTS} $@

return_code=$?
echo "[java-wrapper] Process returned code: ${return_code}"
exit ${return_code}
