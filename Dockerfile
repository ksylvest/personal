ARG RUBY_VERSION="3.2.2"
ARG BUNDLER_VERSION="2.4.18"

# core:

FROM ruby:${RUBY_VERSION}-alpine AS core
WORKDIR /app

ENV NODE_ENV="production"
ENV RAILS_ENV="production"
ENV RAILS_SERVE_STATIC_FILES="on"
ENV RAILS_LOG_TO_STDOUT="on"

RUN \
  apk update && \
  apk upgrade && \
  apk add --no-cache libpq-dev tzdata && \
  gem install bundler --version="${BUNDLER_VERSION}" && \
  bundle config set --local deployment on

# runtime:

FROM core AS runtime
RUN apk add --no-cache build-base
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle check || bundle install

# assets:

FROM runtime AS assets
RUN apk add --no-cache nodejs yarn
COPY package.json .
COPY yarn.lock .
RUN yarn install && yarn cache clean
COPY . .
RUN SECRET_KEY_BASE="SKIP" bundle exec rake assets:precompile

# default:

FROM core
COPY . .
COPY --from=runtime /app /app
COPY --from=assets /app/public/assets /app/public/assets

EXPOSE $PORT
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
