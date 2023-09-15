ARG RUBY_VERSION="3.2.2"
ARG BUNDLER_VERSION="2.4.19"

FROM ruby:${RUBY_VERSION}-slim AS base
WORKDIR /rails

ENV BUNDLE_DEPLOYMENT="on" BUNDLE_WITHOUT="development:test"

FROM base AS build

ENV PATH="/root/.bun/bin:$PATH"

RUN \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential libpq-dev curl zip unzip && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

RUN curl -fsSL https://bun.sh/install | bash

COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

COPY package.json .
COPY bun.lockb .
RUN bun install

COPY . .

RUN SECRET_KEY_BASE="SKIP" bundle exec rake assets:precompile

FROM base

RUN \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y libpq-dev libvips && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

COPY --from=build /rails/public/assets /rails/public/assets
COPY --from=build /rails/vendor/bundle /rails/vendor/bundle

COPY . .

RUN bundle exec bootsnap precompile --gemfile /app /lib

EXPOSE $PORT
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
