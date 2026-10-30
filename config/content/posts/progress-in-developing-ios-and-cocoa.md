---
date: "2013-07-12"
title: Progress in Developing iOS and Cocoa
summary: Blocks, Literals, ARC and more have been added to Cocoa helping to ease many of the pains developers experienced in the past. It is an awesome time to be an iOS or Mac developer.
tags:
  - ios
  - iphone
  - ipad
  - mac
  - cocoa
---

Over the past few iterations of iOS and Cocoa Apple has fundamentally changed the language and improved nearly every aspect. The removal of memory management (and replacement with ARC) has solved more than a few headaches. The addition of short form expressions and blocks means code can be refactored greatly. Here is a code snippet to show just how far the language has come:

Old:

```objc
//
//  SampleTableViewController.m
//  Sample
//
//  Created by Kevin Sylvestre on 13-07-11.
//  Copyright Kevin Sylvestre 2013. All rights reserved.
//

#import "SampleViewController.h"

@implementation SampleViewController

#pragma mark - Authentication

- (void)userSignupSuccess:(User *)user
{
  ...
}

- (void)userSignupFailure:(NSError *)error
{
  ...
}

- (void)signup
{
  NSArray *objects = [NSArray arrayWithObjects:@"Kevin", [NSNumber numberWithInt:24], [NSDate date]];
  NSArray *keys = @"name", @"age", @"modified";
  NSDictionary *params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];

  UserProcessor *up = [[UserProcessor alloc] init];

  up.delegate = self;
  [up create:params];

  [up release];
}

@end
```

**New:**

```objc
//
//  SampleTableViewController.m
//  Sample
//
//  Created by Kevin Sylvestre on 13-07-11.
//  Copyright Kevin Sylvestre 2013. All rights reserved.
//

#import "SampleViewController.h"

@implementation SampleViewController

#pragma mark - Authentication

- (void)signup
{
  [User create:@{ @"name" : @"Kevin", @"age" : @24 }
    withSuccess:^(User *user) { ... }
    andFailure:^(NSError *error) { ... }];
}

@end
```

This isn't the best of it though. An amazing new package manager has taken off that follows a similar format to the Ruby and Python equivalents. It is called [CocoaPods](http://cocoapods.org/) and it rocks!
