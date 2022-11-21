.DEFAULT_GOAL : help
.PHONY : compile start stop remove copy install

ifndef VERSION
override VERSION = snapshot
endif

help:
	@printf "\033[33m%s:\033[0m\n" 'Available commands'
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-30s\033[0m %s\n", $$1, $$2}'

compile: ## Build image; make compile VERSION="snapshot"
	docker build -t ffmpeg-compiler-$(VERSION) --build-arg FFMPEG_VERSION=$(VERSION) .

start: ## Start container (detached); make start VERSION="snapshot"
	docker run -dit --rm --name ffmpeg-compiler-$(VERSION) ffmpeg-compiler-$(VERSION)

stop: ## Stop container; make stop VERSION="snapshot"
	docker stop ffmpeg-compiler-$(VERSION)

remove: ## Remove container; make remove VERSION="snapshot"
	docker rm -f ffmpeg-compiler-$(VERSION)

copy: ## Copy ffmpeg, ffprobe and ffplay binaries from container to host; make copy VERSION="snapshot"
	docker cp ffmpeg-compiler-$(VERSION):/root/bin/. $$HOME/bin/
	. $$HOME/.profile

install: ## Install package.list on host machine; make install
	DEBIAN_FRONTEND=noninteractive sudo apt-get install -y --no-install-recommends $$(grep -o '^[^#]*' ./package.list)
