all: build

build:
	node_modules/.bin/tsc -m commonjs server.ts test/*.test.ts

test:
	bin/test test/*.test.js

install:
	

# oh, cool, if a directory exists, it doesn't rebuild it
.PHONY: test test-w

