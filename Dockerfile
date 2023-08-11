ARG RUBY_VERSION="3.2.2"
ARG BUNDLER_VERSION="2.4.18"

# core:

FROM ruby:${RUBY_VERSION}-alpine AS core
WORKDIR /app

RUN apk update && apk upgrade
RUN apk add --no-cache libpq-dev tzdata
RUN gem install bundler --version="${BUNDLER_VERSION}"
RUN bundle config set --local deployment on

# builder:

FROM core as builder
RUN apk add --no-cache build-base nodejs yarn

# bundle:

FROM builder AS bundle
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle check || bundle install

# yarn:

FROM builder AS yarn
COPY package.json .
COPY yarn.lock .
RUN yarn install && yarn cache clean

# assets:

FROM builder AS assets
COPY . .
COPY --from=bundle /app /app
COPY --from=yarn /app /app
RUN bundle exec rake assets:precompile

# pristine:

FROM core
COPY . .
COPY --from=bundle /app /app
COPY --from=assets /app/public/assets /app/public/assets

EXPOSE $PORT
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
