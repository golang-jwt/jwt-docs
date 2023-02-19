DOCKER ?= docker
# The official docker image is linux/amd64 only. So we use the recommended 
# third-party image as suggested in the docs:
# https://squidfunk.github.io/mkdocs-material/getting-started/?h=docker#with-docker
DOCKER_IMAGE ?= ghcr.io/afritzler/mkdocs-material
DOCKER_BUILD_EXTRA_ARGS ?=

preview:
	$(DOCKER) run --rm -it -p 8000:8000 -v ${PWD}:/docs $(DOCKER_IMAGE) serve --dev-addr=0.0.0.0:8000
