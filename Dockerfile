# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.5

FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

ENV \
  BUNDLE_DEPLOYMENT="1" \
  BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_WITHOUT="development:test" \
  NODE_ENV="production" \
  RAILS_ENV="production" \
  RUBY_YJIT_ENABLE="1"

WORKDIR /rails

FROM base AS build

RUN \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential curl git libpq-dev npm zip unzip && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install && \
  rm -rf "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

RUN SECRET_KEY_BASE="SKIP" ./bin/rails assets:precompile

FROM base

RUN \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY . .
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails/app/assets /rails/app/assets
COPY --from=build /rails/public/assets /rails/public/assets

RUN bundle exec bootsnap precompile --gemfile /app /lib

RUN useradd rails -m -s /bin/bash && \
  chown -R rails:rails log storage tmp
USER rails:rails

ENTRYPOINT ["/rails/bin/entrypoint"]

EXPOSE $PORT
CMD ["./bin/thrust", "./bin/rails", "server"]
