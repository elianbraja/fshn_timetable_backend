FROM ruby:2.6.6-alpine

RUN apk add --update --virtual \
    runtime-deps \
    postgresql-client \
    postgresql-dev \
    build-base \
    libxml2-dev \
    libxslt-dev \
    nodejs \
    yarn \
    libffi-dev \
    readline \
    libc-dev \
    readline-dev \
    linux-headers \
    file \
    git \
    tzdata \
    && rm -rf /var/cache/apk/* \

RUN mkdir /app
WORKDIR /app

ARG RAILS_ENV=production
ENV RAILS_ENV=${RAILS_ENV}

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN gem install bundler
RUN bundle install

ADD . /app

ENV PORT 8080

ARG SERVER_COMMAND="bundle exec puma -C config/puma.rb"
ENV SERVER_COMMAND ${SERVER_COMMAND}
CMD ${SERVER_COMMAND}
