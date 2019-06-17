build:
	docker build -t bambooing:base .
build_devel:
	docker build --target=devel -t bambooing:devel .
build_release:
	docker build --target=release -t bambooing:release .
test:	build_devel
	docker run -it --rm bambooing:devel bundle exec rake spec
devel:	build_devel
	docker run --rm -it -v ${PWD}:/usr/src bambooing:devel bash
create_current_weekdays:  build_release
	docker run --rm --env-file ${PWD}/configuration.env bambooing:release bundle exec rake create_current_weekdays
