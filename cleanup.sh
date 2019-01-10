#!/bin/bash

# Sanity
if [ -z "${APIGEE_USERNAME}" -o -z "${APIGEE_HOST}" -o -z "${APIGEE_ORGANIZATION}" -o -z "${APIGEE_ENV}" ] 
then
    echo "Set using the env file Apigee User, Password, Host, Org, Env to continue"
    exit 1
fi

# Debug - uncomment to debug
#export DEBUG=-D
export VERBOSE=-V

# Summary
echo "#####################################################"
echo APIGEE_USERNAME        ${APIGEE_USERNAME}
echo APIGEE_HOST            ${APIGEE_HOST}
echo APIGEE_ORGANIZATION    ${APIGEE_ORGANIZATION}
echo APIGEE_ENV             ${APIGEE_ENV}
echo "#####################################################"
echo ""
echo ""

# APIGEE_ORGANIZATION, APIGEE_USERNAME, APIGEE_PASSWORD 
# are picked  by apigeetool directly from the environment
# -u ${APIGEE_USERNAME} -p ${APIGEE_PASSWORD} -o ${APIGEE_ORGANIZATION}

echo "Delete App"
apigeetool deleteapp -L ${APIGEE_HOST} ${DEBUG} ${VERBOSE} \
    --name "Perf Test" --email johndoe@example.com

echo ""
echo "Delete Developer"
apigeetool deletedeveloper -L ${APIGEE_HOST} ${DEBUG} ${VERBOSE} \
    --email johndoe@example.com

echo ""
echo "Delete API product"
apigeetool deleteProduct -L ${APIGEE_HOST} ${DEBUG} ${VERBOSE} \
    --productName "Perf Test"


echo "Undeploy APIs"
echo "..."
apigeetool undeploy -L ${APIGEE_HOST} -e ${APIGEE_ENV} ${DEBUG} ${VERBOSE} \
    -n Perf-OAuth

echo "..."
apigeetool undeploy -L ${APIGEE_HOST} -e ${APIGEE_ENV} ${DEBUG} ${VERBOSE} \
    -n Perf-NoTarget

echo "..."
apigeetool undeploy -L ${APIGEE_HOST} -e ${APIGEE_ENV} ${DEBUG} ${VERBOSE} \
    -n Perf-EchoTarget

echo "..."
apigeetool undeploy -L ${APIGEE_HOST} -e ${APIGEE_ENV} ${DEBUG} ${VERBOSE} \
    -n Perf-TransformTarget

echo "Delete APIs"
echo "..."
apigeetool delete -L ${APIGEE_HOST} ${DEBUG} ${VERBOSE} \
    -n Perf-OAuth

echo "..."
apigeetool delete -L ${APIGEE_HOST} ${DEBUG} ${VERBOSE} \
    -n Perf-NoTarget

echo "..."
apigeetool delete -L ${APIGEE_HOST} ${DEBUG} ${VERBOSE} \
    -n Perf-EchoTarget

echo "..."
apigeetool delete -L ${APIGEE_HOST} ${DEBUG} ${VERBOSE} \
    -n Perf-TransformTarget

echo ""
echo "Delete Target Server"
curl -X DELETE \
    -u "${APIGEE_USERNAME}:${APIGEE_PASSWORD}" \
    ${APIGEE_HOST}/v1/organizations/${APIGEE_ORGANIZATION}/environments/${APIGEE_ENV}/targetservers/HTTPBin


echo ""
echo ""
echo ""
echo "Done"
