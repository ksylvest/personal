---
date: "2010-04-22"
title: Non-Blocking Long Running Tasks on iOS
summary: Avoiding delays on the UI thread in iOS is key to ensure a snappy interface. Long running should be queued in operation queues to make sure they don't impact perceived performance.
tags:
  - ios
  - ipad
  - iphone
  - cocoa
  - apple
---

iOS applications should never place long running tasks - such as HTTP requests or data processing - on the main thread. Doing so will cause the thread to block and have a major impact on perceived performance. The following snippet shows how to avoid any sluggishness:

```objc
//
//  SampleTableViewController.m
//  Sample
//
//  Created by Kevin Sylvestre on 10-04-22.
//  Copyright Kevin Sylvestre 2010. All rights reserved.
//

#import "SampleTableViewController.h"

@implementation SampleTableViewController

#pragma mark - Helpers

- (void)load
{
  [NSThread sleepForTimeInterval:4.0];
  self.results = [NSArray arrayWithObjects:@"Canada", @"England", @"France", @"Spain", nil];
  [self.view performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

#pragma mark - Main

- (void)viewDidLoad
{
  [super viewDidLoad];

  NSOperationQueue *queue = [[NSOperationQueue alloc] init];
  [queue addOperation:[[[NSInvocationOperation alloc] initWithTarget:self selector:@selector(load) object:nil] autorelease]];
}

@end
```
