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

[![Circle CI](https://dl.circleci.com/status-badge/img/gh/ksylvest/personal/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/ksylvest/personal/tree/main)
[![Status](https://uptime.betterstack.com/status-badges/v2/monitor/1mhv2.svg)](https://status.ksylvest.com/)

## Copyright

Copyright (c) - All Rights Reserved
