all: build

build:
	node_modules/.bin/tsc server.ts test/*.test.ts

test:
	bin/test test/*.test.js

# oh, cool, if a directory exists, it doesn't rebuild it
.PHONY: test test-w

