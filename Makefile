default: build

DOCKER_IMAGE ?= quay.io/rimusz/beer-service-web
BUILD_NUMBER ?= `git rev-parse --short HEAD`
TAG ?= 1.0

.PHONY: build
build:
	@docker build \
	  -t $(DOCKER_IMAGE):$(BUILD_NUMBER) .

.PHONY: push
push:
	# Push to DockerHub
	docker tag $(DOCKER_IMAGE):$(BUILD_NUMBER) $(DOCKER_IMAGE):latest
	docker tag $(DOCKER_IMAGE):$(BUILD_NUMBER) $(DOCKER_IMAGE):$(TAG)
	docker push $(DOCKER_IMAGE)

.PHONY: all
all: build push
