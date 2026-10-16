NAME := $(shell jq -r .name config.json)
VERSION := $(shell jq -r .version config.json)

CC ?= cc
CFLAGS ?= -Wall -Wextra -O2

CPPFLAGS += -DNAME='"$(NAME)"' -DVERSION='"$(VERSION)"'

SRC := src/wordcount.c
BUILD := build
BIN := $(BUILD)/$(NAME)

.PHONY: check clean

all: $(BIN)

$(BIN): $(SRC) config.json
	@mkdir -p $(@D)
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ $<

check: $(BIN)
	@for t in test/*.txt; do \
		expected="$${t%.txt}.expected"; \
		"$(BIN)" "$$t" | diff -u "$$expected" - || { \
			echo "*** $${t} failed"; \
			exit 1; \
		}; \
	done

clean:
	rm -rf $(BUILD)
