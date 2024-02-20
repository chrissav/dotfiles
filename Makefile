# Credit to https://github.com/jessfraz/dotfiles for the gist of this

.PHONY: all
all: bin dotfiles ## Installs the bin directory files and the dotfiles.

.PHONY: bin
bin: ## Installs the bin directory files.
	# add aliases for things in bin
	for file in $(shell find $(shell pwd)/bin -type f); do \
		f=$$(basename $$file); \
		ln -sf $$file /usr/local/bin/$$f; \
	done;

	# clean broken symlinks in case anything in bin/ is removed or renamed
	find -L /usr/local/bin/ -name -o -type d -prune -o -type l -exec rm {} +;

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles.
	# add aliases for dotfiles
	for file in $(shell find $(shell pwd) -name ".*" -not -name ".gitignore" -not -name ".git"); do \
		f=$$(basename $$file); \
		ln -sfn $$file $(HOME)/$$f; \
	done;

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

