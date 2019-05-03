.PHONY: help
VERSION ?= v0.0.4

help: ## Print out this help info
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build
	go build -o ./bin/splunk-users-sync ./main.go

install:
	go install -v

vet: ## Find common errors
	go vet ./...

image: ## Build docker image
	docker build -t jmervine/unstick:latest .
	docker tag jmervine/unstick:latest jmervine/unstick:$(VERSION)

push: image
	docker push jmervine/unstick:latest
	docker push jmervine/unstick:$(VERSION)
