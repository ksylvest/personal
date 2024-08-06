# syntax = docker/dockerfile:1

ARG RUBY_VERSION=3.3.4

FROM docker.io/library/ruby:${RUBY_VERSION}-slim AS base

ENV \
  BUNDLE_DEPLOYMENT="on" \
  BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_WITHOUT="development:test" \
  NODE_ENV="production" \
  RAILS_ENV="production" \
  PATH="/root/.bun/bin:$PATH"

WORKDIR /rails

FROM base AS build

ENV BUN_INSTALL="/usr/local/bun"
ENV PATH="${BUN_INSTALL}/bin:${PATH}"

RUN \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential curl git libpq-dev npm zip unzip && \
  curl -fsSL https://bun.sh/install | bash && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install && \
  rm -rf "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY package.json bun.lockb ./
RUN \
  # --mount=type=cache,target=/root/.bun,sharing=locked \
  bun install

COPY . .

FROM build AS assets

RUN SECRET_KEY_BASE="SKIP" ./bin/rails assets:precompile

FROM build AS local

ENTRYPOINT ["/rails/bin/entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]

FROM base

RUN \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=assets . .

RUN rm -rf ${BUNDLE_PATH}/ruby/*/cache ${BUNDLE_PATH}/ruby/*/bundler/gems/*/.git
RUN rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN bundle exec bootsnap precompile --gemfile /app /lib

RUN useradd rails -m -s /bin/bash && chown -R rails:rails log storage tmp
USER rails:rails

ENTRYPOINT ["/rails/bin/entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
