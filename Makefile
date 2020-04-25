JEKYLL_VERSION		:= stable

all: sync

pull:
	docker pull \
		jekyll/builder:${JEKYLL_VERSION}
.PHONY: pull

build: pull
	docker run --rm \
		--volume=${HOME}/Library/Caches/jekyll:/usr/local/bundle \
		--volume=${PWD}:/srv/jekyll \
		jekyll/builder:${JEKYLL_VERSION} \
		jekyll build
.PHONY: build

sync: build
	rsync -avPHS --delete _site/ co-lo.night-shade.org.uk:/data/blog/
.PHONY: sync
