VERSION ?= 0.2.7
RUST_VERSION ?= 1.43.1
# REPO ?= softprops/lambda-rust
REPO ?= tc1io/lambda-rust
TAG ?= "$(REPO):$(VERSION)-rust-$(RUST_VERSION)"
TAG_NIGHTLY ?= "$(REPO):$(VERSION)-rust-$(RUST_VERSION)-nightly"

publish: build
	@docker push $(TAG)
	@docker push $(REPO):latest

build:
	@docker build --build-arg RUST_VERSION=$(RUST_VERSION) -t $(TAG) .
	@docker tag $(TAG) $(REPO):latest

test: build
	@tests/test.sh

debug: build
	@docker run --rm -it \
		-v ${PWD}:/code \
		-v ${HOME}/.cargo/registry:/root/.cargo/registry \
		-v ${HOME}/.cargo/git:/root/.cargo/git  \
		--entrypoint=/bin/bash \
		$(REPO)
publish-nightly: build-nightly
	@docker push $(TAG_NIGHTLY)
	@docker push $(REPO):latest

build-nightly:
	@docker build --build-arg RUST_VERSION=$(RUST_VERSION) -t $(TAG_NIGHTLY) -f Dockerfile-Nightly .
	@docker tag $(TAG_NIGHTLY) $(REPO):latest

test-nightly: build-nightly
	@tests/test.sh

debug-nightly: build-nightly
	@docker run --rm -it \
		-v ${PWD}:/code \
		-v ${HOME}/.cargo/registry:/root/.cargo/registry \
		-v ${HOME}/.cargo/git:/root/.cargo/git  \
		--entrypoint=/bin/bash \
		$(REPO)