all: build

build:
	cd server && make && cd ..
	cd public && make && cd ..

install:
	cd server && npm install && cd ..
	# bower components will get synched with rsync

upload:
	# sync all the files
	rsync -rav -e ssh --delete --exclude-from config/exclude.txt . root@libros.orbit.al:~/libros

deploy: upload
	# run the remote commands
	ssh -t root@libros.orbit.al "cd ~/libros && bash config/deploy.sh"
