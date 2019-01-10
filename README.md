# apigee_perf_test
Perf Test suite to validate capacity of an on premise Apigee installation.

### Prerequisite
Some of the tests require a backend. [[http://httpbin.org]] is a great echo service. Run it locally as a docker image to get a good measure of performance. IMPORTANT do not flood the cloud service.

[[$ docker run -p 80:80 kennethreitz/httpbin]] or find a fork here [[https://github.com/msadasivam/httpbin]]

Set the host and port of the service as BACKEND_* variables in env.sh below.

### Setup
    cp env.sh.sample env.sh
    # update env with your Apigee details
    source env.sh
    setup.sh


### Perf Testing
Use your favourite tool

NoTarget - Raw Apigee infra capacity

    curl -X GET \
        http://johngrant-trial-test.apigee.net/perf/v1/info

Echo Target - Passthrough proxy to an echo backend

    curl -X GET \
        http://johngrant-trial-test.apigee.net/perf/v1/echo/get

OAuth token

    curl -X POST \
        https://johngrant-trial-test.apigee.net/perf/v1/oauth/token \
        -H 'Authorization: Basic Y0V2ZThLV3VlaEgyUkg1NnJVaUwySEtWejFmMmd2WjM6V0FVeElMg==' \
        -H 'Content-Type: application/x-www-form-urlencoded' \
        -d 'grant_type=client_credentials&undefined='

Transform target (acquire and use oauth access token)

    curl -X GET \
        http://johngrant-trial-test.apigee.net/perf/v1/transform/slides \
        -H 'Authorization: Bearer 4SqugHGQYzHqOsufcdw2KkQB7'


### Cleanup
    cp env.sh.sample env.sh
    # update env with your Apigee details
    source env.sh
    cleanup.sh

### Postman collection
Import postman files found in ./testtools to Postman [Verified on postman 6.6.1]
