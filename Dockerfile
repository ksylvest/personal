ARG RUBY_VERSION=3.2.2

FROM ruby:${RUBY_VERSION}-alpine

RUN \
  apk update && \
  apk upgrade && \
  apk add --update --no-cache build-base libpq-dev tzdata nodejs yarn

WORKDIR /app

COPY Gemfile .
COPY Gemfile.lock .
RUN bundle config set --local deployment on
RUN bundle check || bundle install

COPY package.json .
COPY yarn.lock .
RUN yarn install && yarn cache clean

COPY . .

RUN bundle exec bootsnap precompile --gemfile app/ lib/

EXPOSE $PORT
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
