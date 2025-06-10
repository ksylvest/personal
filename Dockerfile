# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.4.4

FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

WORKDIR /rails

RUN \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

ENV \
  BUNDLE_DEPLOYMENT="1" \
  BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_WITHOUT="development:test" \
  NODE_ENV="production" \
  RAILS_ENV="production" \
  RUBY_YJIT_ENABLE="1"

FROM base AS build

RUN \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential gnupg git libpq-dev libyaml-dev node-gyp pkg-config && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

ARG NODE_VERSION=23.3.0
ENV PATH=/usr/local/node/bin:$PATH
RUN curl -sL https://github.com/nodenv/node-build/archive/master.tar.gz | tar xz -C /tmp/ && \
  /tmp/node-build-master/bin/node-build "${NODE_VERSION}" /usr/local/node && \
  rm -rf /tmp/node-build-master

COPY Gemfile Gemfile.lock ./
RUN bundle install && \
  rm -rf "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY package.json package-lock.json ./
RUN npm ci

COPY . .

RUN SECRET_KEY_BASE="SKIP" ./bin/rails assets:precompile

FROM base

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
CMD ["./bin/rails", "server"]
