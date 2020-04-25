JEKYLL_VERSION		:= stable

all: build

build:
	docker pull \
		jekyll/builder:${JEKYLL_VERSION}
	docker run --rm \
		--volume="$HOME/Library/Caches/gemcache:/usr/local/bundle" \
		--volume="$PWD:/srv/jekyll" \
		jekyll/builder:${JEKYLL_VERSION} \
		jekyll build 
.PHONY: build

sync: build
	rsync -avPHS --delete _site/ \
    co-lo.night-shade.org.uk:/data/blog/
.PHONY: sync
