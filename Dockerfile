ARG RUBY_VERSION=3.2.2

FROM ruby:${RUBY_VERSION}-alpine AS core

RUN \
  apk update && \
  apk upgrade && \
  apk add --update --no-cache build-base libpq-dev tzdata nodejs yarn

WORKDIR /app

RUN bundle config set --local deployment on

FROM core AS bundler
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle check || bundle install

FROM core AS yarn
COPY package.json .
COPY yarn.lock .
RUN yarn install && yarn cache clean

COPY . .

RUN bundle exec bootsnap precompile --gemfile app/ lib/
COPY . .
COPY --from=bundler /app /app
COPY --from=yarn /app /app

EXPOSE $PORT
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
