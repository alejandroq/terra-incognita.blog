#
# Shortcuts to common Gitbook commands
#

# Change to the name you'd like to use for your book output files
BOOK_NAME := lab-001-electronic-publishing

# Container meta-info
BIN := hugo
REGISTRY ?= hassiumlabs
    IMAGE := $(REGISTRY)/$(BIN)
CONTAINER := $(REGISTRY)-$(BIN)

# The base command to run the Gitbook container
RUN_CMD := @docker run --rm -v $$(pwd):/srv/gitbook $(IMAGE)

GITBOOK_CMD := $(RUN_CMD) $(BIN)

# Slightly different options and a name so we can kill easily
SERVE_CMD := @docker run               \
               -p 4000:4000 --rm       \
               -v $$(pwd):/srv/gitbook \
               --name "$(CONTAINER)"   \
               $(IMAGE) $(BIN)

all: html pdf mobi epub

# Rebuild the docker container
# Must be run from the directory containing the Dockerfile
buildimage:
@docker build -t $(IMAGE) .

# Gitbook Actions

bookdir:
@mkdir -p _book

clean:
@rm -fr _book node_modules

init: stop
$(GITBOOK_CMD) init

install:
    $(GITBOOK_CMD) install > /dev/null 2>&1

html: install
$(GITBOOK_CMD) build

epub: bookdir install
$(GITBOOK_CMD) epub . ./_book/$(BOOK_NAME).epub

mobi: bookdir install
$(GITBOOK_CMD) mobi . ./_book/$(BOOK_NAME).mobi

pdf: bookdir install
$(GITBOOK_CMD) pdf . ./_book/$(BOOK_NAME).pdf

serve: bookdir install
$(SERVE_CMD) serve > /dev/null 2>&1 &

status:
@docker ps --filter="name=$(CONTAINER)"

stop:
@docker kill $(shell docker ps --filter=\"name=$(CONTAINER)\" -q) > /dev/null 2>&1 || true

version:
    $(GITBOOK_CMD) version

# Gitbook Theme Actions
# For use with themes such as https://github.com/GitbookIO/theme-default

themeinit:
    $(RUN_CMD) npm update

themebuild:
    $(RUN_CMD) ./src/build.sh
