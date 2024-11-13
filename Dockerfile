FROM ruby:3.3.4-alpine3.20 AS base
ENV APP=/opt
WORKDIR $APP
COPY Gemfile bambooing.gemspec Rakefile $APP/

FROM base AS test
RUN apk --update add --virtual build_deps build-base
COPY lib $APP/lib/
COPY spec $APP/spec/
RUN bundle install -j 10 --quiet
RUN apk del build_deps
