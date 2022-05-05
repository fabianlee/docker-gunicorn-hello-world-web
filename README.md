# Summary
Python Flask app running in Gunicorn by default on port 8000 that is intended for testing containers, especially from Kubernetes

Image is based on python:3.10-slim-bullseye and is ~140Mb

# Environment variables

* PORT - listen port, defaults to 8000
* APP_CONTEXT - base context path of app, defaults to '/'

# Environment variables populated from Downward API
* MY_NODE_NAME - name of k8s node
* MY_POD_NAME - name of k8s pod
* MY_POD_IP - k8s pod IP
* MY_POD_SERVICE_ACCOUNT - service account of k8s pod

# Prerequisites
* make utility (sudo apt-get install make)

# Makefile targets
* docker-build (builds image)
* docker-run-fg (runs container in foreground, ctrl-C to exit)
* docker-run-bg (runs container in background)
* k8s-apply (applies deployment to kubernetes cluster)
* k8s-delete (removes deployment on kubernetes cluster)

# Docker images

fabianlee/docker-gunicorn-hello-world-web:1.0.0

git tag -a 1.0.0 -m "version 1.0.0 of build does not have New Relic agent"
git push --tags


fabianlee/docker-gunicorn-hello-world-web:2.0.0

git tag -a 2.0.0 -m "version 2.0.0 of build has New Relic agent instrumentation"
git push --tags
