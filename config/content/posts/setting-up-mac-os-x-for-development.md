---
date: "2012-07-28"
title: Setting Up Mac OS X For Development
summary: Configuring a new Mac for development can be tricky. These steps will get any machine setup with Ruby, Node, Postgres and lots more.
tags:
  - ruby
  - node
  - postgres
  - fish
  - memcache
  - elasticsearch
  - redis
  - pow
---

# Setup

## Step 1. Install Xcode

1. Open the App Store (located in the dock)
2. Search for ‘Xcode’ and install
3. Open ‘Xcode’ and select Preferences (⌘,)
4. On the ‘Downloads’ tab install the ‘Command Line Utilities’

## Step 2: Install XQuartz

1. Browse to http://xquartz.macosforge.org/landing/
2. Download the latest DMG and run the XQuartz.pkg

## Step 3. Install Everything

1. From Terminal: curl -sL https://raw.github.com/ksylvest/setup/master/setup.sh | bash
