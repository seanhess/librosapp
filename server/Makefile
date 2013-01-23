all: build

build:
	node_modules/.bin/tsc server.ts test/*.test.ts

test: build
	NODE_ENV=test node_modules/.bin/mocha --reporter dot test/*.test.js

test-w: build
	NODE_ENV=test node_modules/.bin/mocha --reporter dot --growl --watch test/*.test.js

# oh, cool, if a directory exists, it doesn't rebuild it
.PHONY: test test-w

