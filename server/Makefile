all: build

build:
	node_modules/.bin/tsc server.ts

nothing:
	echo "Nothing"

#api-build:
	## doesn't work to to --out if you use the module pattern at all
	#node_modules/.bin/tsc api/server.ts

#public-build:
	#node_modules/.bin/tsc --out public/main.js public/app.ts

#install:
	#npm install
	#node_modules/.bin/bower install

#upload:
	## sync all the files
	#rsync -rav -e ssh --delete --exclude-from config/exclude.txt . deploy@bazookaguys:~/bazookaguys

#deploy: upload
	## run the remote commands
	#ssh -t deploy@bazookaguys "cd ~/bazookaguys && config/deploy.sh"

#test-upload: 
	#rsync -rav -e ssh --delete --exclude-from config/exclude.txt . deploy@bazookaguys:~/test.bazookaguys

#test-deploy: test-upload
	#ssh -t deploy@bazookaguys "cd ~/test.bazookaguys && config/deploy.sh"

# doesn't work yet! it clobbers the angularjs parameter names!
#optimize: build
	#node_modules/.bin/uglifyjs --overwrite --no-copyright --no-mangle --verbose public/main.js > public/main-uglified.js
	#rm public/main.js
	#mv public/main-uglified.js public/main.js
