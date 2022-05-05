OWNER := fabianlee
PROJECT := docker-gunicorn-hello-world-web
VERSION := 1.0.0
OPV := $(OWNER)/$(PROJECT):$(VERSION)
EXPOSED_PORT := 8000
CONTAINER_PORT := 8000
WEBPORT := $(EXPOSED_PORT):$(CONTAINER_PORT)

# you may need to change to "sudo docker" if not a member of 'docker' group
DOCKERCMD := "docker"

BUILD_TIME := $(shell date -u '+%Y-%m-%d_%H:%M:%S')
# unique id from last git commit
MY_GITREF := $(shell git rev-parse --short HEAD)


## builds docker image
docker-build:
	@echo MY_GITREF is $(MY_GITREF)
	$(DOCKERCMD) build -f Dockerfile -t $(OPV) .

## cleans docker image
clean:
	$(DOCKERCMD) image rm $(OPV) | true

## runs container in foreground, testing a couple of override values
docker-test-fg:
	# Other env vars that can be overridden
	# -e APP_CONTEXT=/gunicorn
	# -e GUNICORN_WORKERS=3
	# -e GUNICORN_BIND=0.0.0.0:8000
	$(DOCKERCMD) run -it -p $(WEBPORT) -e GUNICORN_WORKERS=3 -e GUNICORN_BIND=0.0.0.0:$(CONTAINER_PORT) --rm $(OPV)

## runs container in foreground, override entrypoint to use use shell
docker-test-cli:
	$(DOCKERCMD) run -it --rm --entrypoint "/bin/sh" $(OPV)

## run container in background
docker-run-bg:
	$(DOCKERCMD) run -d -p $(WEBPORT) --rm --name $(PROJECT) $(OPV)

## get into console of container running in background
docker-cli-bg:
	$(DOCKERCMD) exec -it $(PROJECT) /bin/sh

## tails $(DOCKERCMD)logs
docker-logs:
	$(DOCKERCMD) logs -f $(PROJECT)

## stops container running in background
docker-stop:
	$(DOCKERCMD) stop $(PROJECT)

## pushes to $(DOCKERCMD)hub
docker-push:
	$(DOCKERCMD) push $(OPV)

## pushes to kubernetes cluster
k8s-apply:
	sed -e 's/1.0.0/$(VERSION)/' flask-hello-world-web.yaml | kubectl apply -f -

k8s-delete:
	kubectl delete -f flask-hello-world-web.yaml 