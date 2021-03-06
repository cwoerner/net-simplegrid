#!/bin/bash

if [ -z "$GRID_MGR_HOME" ]; then 
    GRID_MGR_HOME=/opt/simple-grid;
fi;

if [ -r "${GRID_MGR_HOME}/bin/config.sh" ]; then 
    . ${GRID_MGR_HOME}/bin/config.sh
fi;

if [ -z "${GRID_MGR_ARGS}" ]; then echo "missing GRID_MGR_ARGS"; exit 1; fi;
if [ -z "${SLAVE_KIDS}" ]; then SLAVE_KIDS=2; fi;


CMD="perl  -I${GRID_MGR_HOME}/lib -I${GRID_MGR_HOME}/perl/sitelib ${GRID_MGR_HOME}/bin/slave.pl -m $SLAVE_KIDS $GRID_MGR_ARGS -t $*";
echo $CMD;
$CMD;

