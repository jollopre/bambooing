build:
	docker build -t bambooing:latest .
test:
	docker run --rm bambooing:latest rspec
devel:
	docker run --rm -it -v ${PWD}:/usr/src bambooing:latest bash
	
