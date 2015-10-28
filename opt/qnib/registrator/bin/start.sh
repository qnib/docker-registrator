#!/bin/bash

if [ "X${REGISTRATOR_ADDV_IP}" != "X" ];then
   IP="-ip ${REGISTRATOR_ADDV_IP}"
fi
if [ "X${REGISTRATOR_INTERAL_PORTS}" == "Xtrue" ];then
   INTER="-internal=true"
fi

/usr/local/bin/registrator ${INTER} ${IP} consul://consul.service.consul:8500
