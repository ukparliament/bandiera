FROM ruby:2.4.2-alpine

MAINTAINER Darren Oakley <daz.oakley@gmail.com>

# Add command line argument variables used to cusomise the image at build-time.
ARG RACK_ENV
ARG DATABASE_URL
ARG LOG_TO_STDOUT

# Set up environment
ENV RACK_ENV $RACK_ENV
ENV DATABASE_URL $DATABASE_URL
ENV LOG_TO_STDOUT $LOG_TO_STDOUT

RUN apk add --update --no-cache build-base ruby-dev libxml2-dev libxslt-dev postgresql-dev mysql-dev openssl-dev

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --retry 10 --jobs 4 --without test

COPY . .

EXPOSE 5000

CMD bundle exec rake db:migrate && puma
