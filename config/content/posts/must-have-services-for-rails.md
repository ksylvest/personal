---
date: "2010-05-12"
title: Must Have Services for Rails
summary: Rails is amazing and can be even better when paired with great web services. Heroku, Amazon, Zencoder, Twilio, Tropo and New Relic all fit the bill.
tags:
  - ruby
  - rails
  - heroku
  - zencoder
  - twilio
  - tropo
  - newrelic
  - amazon
---

Ruby on Rails is what it is because of all the great services that extend and augment it. Here is a quick overview of some services that make creating web apps downright cool.

# Hosting

[Heroku](http://heroku.com/) provides online "cloud" hosting for Ruby applications (Sinatra, Rails, etc.). It uses GIT to deploy and runs on Amazon Elastic Cloud Compute servers. The service is free for small applications and deployment can be done in under a minute. Not only will Heroku host your application but they will also host your data.

# Files

Almost every application has some data that does not fit (well) into a database. Picture, video and audio files are all best placed on massive storage. For this, [Amazon Simple Storage Solution](http://aws.amazon.com/s3/) offers good performance for amazingly low prices (around two cents per GB).

# Encoding

Services like [YouTube](http://www.youtube.com/) and [Vimeo](http://vimeo.com/) let users upload video files that can then be viewed in the web browser. Implementing this functionality in an application is easy with [Zencoder](http://zencoder.com/en/).

# Telephony

Need an application to be able to answer the phone? Want to notify your users of events by SMS? Setting up a PBX to do this is daunting. Using [Twilio](http://www.twilio.com/) or [Tropo](https://www.tropo.com/) will accelerate development time by giving a simple XML web service making and receiving calls or SMS. Both services offer free trial time for development.

# Monitoring

Most applications require some form of monitoring (exceptions, performance, activity). For this it is worth taking a look at the great service [New Relic](http://newrelic.com/).
