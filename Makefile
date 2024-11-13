.PHONY: build create_current_weekdays create_current_month_weekdays clean down install shell test up

build:
	docker build --no-cache -t bambooing:test .

create_current_weekdays:
	docker run --rm --name bambooing_week --env-file ${PWD}/configuration.env bambooing:test bundle exec rake bambooing:create_current_weekdays

create_current_month_weekdays:
	docker run --rm --name bambooing_month --env-file ${PWD}/configuration.env bambooing:test bundle exec rake bambooing:create_current_month_weekdays

clean:
	docker rm -f bambooing
	docker rmi bambooing:test

down:
	docker rm -f bambooing

install:
	docker exec -it bambooing bundle install

shell:
	docker exec -it bambooing sh

test:
	docker run --rm --name bambooing_test bambooing:test bundle exec rspec

up:
	docker run --name bambooing -v ${PWD}:/opt --env-file ${PWD}/configuration.env -d bambooing:test tail -f /dev/null
