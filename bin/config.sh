#!/bin/bash

if [ -z "$GRID_MGR_HOME" ]; then 
    GRID_MGR_HOME=/opt/simple-grid;
fi;

if [ -z "${SADDR}" ]; then 

    SADDR_FILE=${GRID_MGR_HOME}/conf/server.addr;

    if [ -r $SADDR_FILE ]; then 
	SADDR=`cat $SADDR_FILE`;
    fi;
fi;

if [ -z ${SADDR} ]; then echo "missing server.addr.  There must be a valid mysql server address in $SADDR_FILE"; exit 1; fi;

if [ ! -z `which dnsdomainname` ]; then DOMAINNAME="--manager_arg=domain=`dnsdomainname`"; fi;

GRID_MGR_ARGS="--manager_arg=dsn=dbi:mysql:database=CHANGEME;host=${SADDR};port=3306 --manager_arg=username=CHANGEME --manager_arg=password=CHANGEME $DOMAINNAME"
