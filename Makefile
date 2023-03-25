DOCKER ?= docker
DOCKER_IMAGE ?= squidfunk/mkdocs-material
DOCKER_BUILD_EXTRA_ARGS ?=

preview:
	$(DOCKER) run --rm -it -p 8000:8000 -v ${PWD}:/docs $(DOCKER_IMAGE) serve --dev-addr=0.0.0.0:8000
