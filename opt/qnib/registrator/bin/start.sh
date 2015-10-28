#!/bin/bash

if [ "X${REGISTRATOR_ADDV_IP}" != "X" ];then
   if [ "X${REGISTRATOR_INTERAL_IP}" == "Xtrue" ];then
       echo "ERROR! >> REGISTRATOR_INTERAL_IP==true will overrule REGISTRATOR_ADDV_IP=='${REGISTRATOR_ADDV_IP}', so choose one!"
       cp /opt/qnib/registrator/etc/registrator_warn.json /etc/consul.d/registrator.json
       consul reload
   fi 
   IP="-ip ${REGISTRATOR_ADDV_IP}"
fi
if [ "X${REGISTRATOR_INTERAL_IP}" == "Xtrue" ];then
   INTER="-internal=true"
fi

/usr/local/bin/registrator ${INTER} ${IP} consul://consul.service.consul:8500
