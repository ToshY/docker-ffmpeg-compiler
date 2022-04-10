.DEFAULT_GOAL : help
.PHONY : build remove

help:
	@printf "\033[33m%s:\033[0m\n" 'Available commands'
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[32m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build image and copy binaries; make build version="snapshot"
	docker build -t ffmpeg-compiler-$(version) --build-arg FFMPEG_VERSION=$(version) .
	docker run -dit --rm --name ffmpeg-compiler ffmpeg-compiler-$(version)
	docker cp ffmpeg-compiler:/root/bin/ $$HOME/bin/
	docker stop ffmpeg-compiler
	. $$HOME/.profile

remove: ## Remove image; make remove version="snapshot"
	docker rm -f ffmpeg-compiler-$(version)
