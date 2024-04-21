#!/bin/bash

set -e errexit

MAX_RESTARTS=3
NAMESPACE='sre'
DEPLOYMENT_NAME='swype-app'

while true; do

    CURRENT_RESTARTS=$(kubectl get pods -n ${NAMESPACE} -l app=${DEPLOYMENT_NAME} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")
    echo "Current restart count: ${CURRENT_RESTARTS}"

    if [ $CURRENT_RESTARTS -gt $MAX_RESTARTS ] ; then
        echo "Max restart count reached, scaling down the deployment to 0"
        kubectl scale deployment ${DEPLOYMENT_NAME} -n ${NAMESPACE} --replicas=0
        break
    fi

    sleep 60

done