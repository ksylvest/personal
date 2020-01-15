# Personal

## Configuration

```bash
./bin/setup
```

## Deployment

```bash
heroku create personal
heroku addons:add redis
heroku addons:add scheduler
heroku addons:add newrelic
heroku addons:add papertrail
heroku domains:add ksylvest.com
git push heroku master
heroku run rake db:setup
```

## Configuration

```bash
EDITOR="atom --wait" bin/rails credentials:edit
```

## Status

[![Circle CI](https://circleci.com/gh/ksylvest/personal.svg?style=svg&circle-token=6e4ea9b30a1b2fef20c46dd20b75dd6e12fc2b81)](https://circleci.com/gh/ksylvest/personal)
[![Maintainability](https://api.codeclimate.com/v1/badges/6c1a7c3b1e87c843246e/maintainability)](https://codeclimate.com/github/ksylvest/personal/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/6c1a7c3b1e87c843246e/test_coverage)](https://codeclimate.com/github/ksylvest/personal/test_coverage)

## Copyright

Copyright (c) - All Rights Reserved
