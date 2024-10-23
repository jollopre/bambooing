FROM ruby:2.6.3 AS base

ENV APP=/usr/src

WORKDIR $APP

COPY Gemfile bambooing.gemspec Rakefile $APP/
COPY lib/bambooing/version.rb $APP/lib/bambooing/version.rb

FROM base AS devel

COPY bin $APP/bin
COPY lib $APP/lib
COPY spec $APP/spec

RUN bundle install -j 10

FROM base AS release

COPY lib $APP/lib

RUN bundle install -j 10
