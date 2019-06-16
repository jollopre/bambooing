FROM ruby:2.6.3 as base

ENV APP /usr/src

WORKDIR $APP

COPY Gemfile bambooing.gemspec Rakefile $APP/
COPY lib/bambooing/version.rb $APP/lib/bambooing/version.rb

FROM base as devel

COPY bin $APP/bin
COPY lib $APP/lib
COPY spec $APP/spec

RUN bundle install -j 10

FROM base as release

COPY lib $APP/lib

RUN bundle install -j 10
