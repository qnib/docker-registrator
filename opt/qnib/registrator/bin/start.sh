#!/bin/bash

source /opt/qnib/consul/etc/bash_functions.sh

wait_for_srv consul

if [ "X${REGISTRATOR_ADDV_IP}" != "X" ];then
   if [ "X${REGISTRATOR_INTERAL_IP}" == "Xtrue" ];then
       echo "ERROR! >> REGISTRATOR_INTERAL_IP==true will overrule REGISTRATOR_ADDV_IP=='${REGISTRATOR_ADDV_IP}', so choose one!"
       cp /opt/qnib/registrator/etc/registrator_warn.json /etc/consul.d/registrator.json
       consul reload
   fi 
   IP="-ip ${REGISTRATOR_ADDV_IP}"
fi
if [ "X${REGISTRATOR_ADDV_CONFD}" == "Xtrue" ];then
    if [ ! -f /conf.d/hostname ];then
       echo "WARN >> REGISTRATOR_INTERAL_CONFD==true but no /conf.d/hostname found... :("
       cp /opt/qnib/registrator/etc/registrator_warn.json /etc/consul.d/registrator.json
       sed -e "s#\"script\": \"echo.*#\"script\": \"echo 'WARN >> REGISTRATOR_INTERAL_CONFD==true but no /conf.d/hostname found... :' ; exit 1\",#" /etc/consul.d/registrator.json
       consul reload
    else
       source /conf.d/hostname
       if [ -z $hostname ];then
           echo 'WARN >> REGISTRATOR_INTERAL_CONFD==true but /conf.d/hostname does not provide a ${hostname} :('
           cp /opt/qnib/registrator/etc/registrator_warn.json /etc/consul.d/registrator.json
           sed -e "s#\"script\": \"echo.*#\"script\": \"echo 'WARN >> REGISTRATOR_INTERAL_CONFD==true but /conf.d/hostname does not provide a \${hostname} :(' ; exit 1\",#" /etc/consul.d/registrator.json
           consul reload
       else
           IP="-ip ${hostname}"
       fi
    fi
fi
if [ "X${REGISTRATOR_INTERAL_IP}" == "Xtrue" ];then
   INTER="-internal=true"
fi
# In- / Exclude
if [ "X${REGISTRATOR_FILTER_INCLUDE}" != "X" ];then
   INCLUDE=" --include=${REGISTRATOR_FILTER_INCLUDE}"
fi
if [ "X${REGISTRATOR_FILTER_EXCLUDE}" != "X" ];then
   EXCLUDE=" --exclude=${REGISTRATOR_FILTER_EXCLUDE}"
fi
#### Define the target via hostname or environment
# default
CONSUL_TARGET=consul.service.consul
if [ "X${REGISTRATOR_CONSUL_TARGET_CONFD}" == "Xtrue" ];then
    if [ ! -f /conf.d/hostname ];then
       echo "WARN >> REGISTRATOR_CONSUL_TARGET_CONFD==true but no /conf.d/hostname found... :("
       cp /opt/qnib/registrator/etc/registrator_warn.json /etc/consul.d/registrator.json
       sed -e "s#\"script\": \"echo.*#\"script\": \"echo 'WARN >> REGISTRATOR_CONSUL_TARGET_CONFD==true but no /conf.d/hostname found... :' ; exit 1\",#" /etc/consul.d/registrator.json
       consul reload
    else
       source /conf.d/hostname
       if [ -z $hostname ];then
           echo 'WARN >> REGISTRATOR_CONSUL_TARGET_CONFD==true but /conf.d/hostname does not provide a ${hostname} :('
           cp /opt/qnib/registrator/etc/registrator_warn.json /etc/consul.d/registrator.json
           sed -e "s#\"script\": \"echo.*#\"script\": \"echo 'WARN >> REGISTRATOR_CONSUL_TARGET_CONFD==true but /conf.d/hostname does not provide a \${hostname} :(' ; exit 1\",#" /etc/consul.d/registrator.json
           consul reload
       else
           CONSUL_TARGET="${hostname}"
       fi
    fi
elif [ "X${REGISTRATOR_CONSUL_TARGET}" != "X" ];then
   CONSUL_TARGET=${REGISTRATOR_CONSUL_TARGET}
fi

/usr/local/bin/registrator ${EXCLUDE} ${INCLUDE} ${INTER} ${IP} consul://${CONSUL_TARGET}:8500
