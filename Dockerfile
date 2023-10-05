ARG RUBY_VERSION="3.2.2"

FROM ruby:${RUBY_VERSION}-slim AS base

ARG BUNDLER_VERSION="2.4.20"
ARG YARN_VERSION="1.22.19"

ENV BUNDLE_DEPLOYMENT="on" BUNDLE_PATH="/usr/local/bundle"

WORKDIR /rails

RUN \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y curl libpq-dev libvips npm wget && \
  npm install -g yarn@${YARN_VERSION} && \
  gem install bundler:${BUNDLER_VERSION} && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

FROM base AS build

RUN \
  apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives

COPY Gemfile .
COPY Gemfile.lock .
COPY .ruby-version .
RUN bundle install && \
  rm -rf "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

COPY package.json .
COPY yarn.lock .
RUN yarn install

COPY . .

RUN SECRET_KEY_BASE="SKIP" ./bin/rails assets:precompile

FROM base

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

RUN bundle exec bootsnap precompile --gemfile /app /lib

RUN useradd rails -m -s /bin/bash && \
  chown -R rails:rails log storage tmp
USER rails:rails

ENTRYPOINT ["/rails/bin/entrypoint"]

EXPOSE $PORT
CMD ["./bin/rails", "server"]
