#!/bin/bash

# Sanity
if [ -z "${APIGEE_USERNAME}" -o -z "${APIGEE_HOST}" -o -z "${APIGEE_ORGANIZATION}" -o -z "${APIGEE_ENV}" ] 
then
    echo "Set using the env file Apigee User, Password, Host, Org, Env to continue"
    exit 1
fi

if [ ! -d apis ]
then
    echo "Cannot find apis directory"
    exit 1
fi

# Debug - uncomment to debug
export DEBUG=" -V --insecure"
#export DEBUG="-D -V --insecure"

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

echo "Create Target Server"
curl -X POST \
    -H 'Content-Type: application/json' \
    -d '{ "name":"HTTPBin", "host":"'${BACKEND_HOST}'", "isEnabled":true, "port":'${BACKEND_PORT}' }' \
    -u "${APIGEE_USERNAME}:${APIGEE_PASSWORD}" \
    ${APIGEE_HOST}/v1/organizations/${APIGEE_ORGANIZATION}/environments/${APIGEE_ENV}/targetservers

echo ""
echo "Deploy APIs"
echo "..."
apigeetool deployproxy -L ${APIGEE_HOST} -e ${APIGEE_ENV} ${DEBUG} \
    -n Perf-OAuth -d apis/Perf-OAuth

echo "..."
apigeetool deployproxy -L ${APIGEE_HOST} -e ${APIGEE_ENV} ${DEBUG} \
    -n Perf-NoTarget -d apis/Perf-NoTarget

echo "..."
apigeetool deployproxy -L ${APIGEE_HOST} -e ${APIGEE_ENV} ${DEBUG} \
    -n Perf-EchoTarget -d apis/Perf-EchoTarget

echo "..."
apigeetool deployproxy -L ${APIGEE_HOST} -e ${APIGEE_ENV} ${DEBUG} \
    -n Perf-TransformTarget -d apis/Perf-TransformTarget

echo ""
echo "Create API product"
apigeetool createProduct -L ${APIGEE_HOST} ${DEBUG} \
    --productName "Perf Test" \
    --productDesc="Perf Test on premises installation of Apigee" \
    --approvalType auto --environments ${APIGEE_ENV} \
    --proxies "Perf-OAuth,Perf-TransformTarget"

echo ""
echo "Create Developer"
apigeetool createdeveloper -L ${APIGEE_HOST} ${DEBUG} \
    --firstName John --lastName Doe \
    --userName johndoe@example.com --email johndoe@example.com

echo ""
echo "Create App"
apigeetool createapp -L ${APIGEE_HOST} ${DEBUG} \
    --name "Perf Test" --apiProducts "Perf Test" \
    --email johndoe@example.com

echo ""
echo ""
echo "Done"
