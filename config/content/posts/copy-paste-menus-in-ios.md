---
date: "2010-03-25"
title: Copy Paste Menus in iOS
summary: Copy and Paste Menus in iOS can be tricky to setup. This code example should help with the basic syntax for getting one up.
tags:
  - ios
  - ipad
  - iphone
  - cocoa
  - apple
---

UIMenuController is an interface to cut, copy, paste, select, and delete. Here is a snippet showing how to set one up:

```objc
//
//  SampleViewController.m
//  Sample
//
//  Created by Kevin Sylvestre on 10-03-25.
//  Copyright Kevin Sylvestre 2010. All rights reserved.
//

#import "SampleViewController.h"

@implementation SampleViewController

#pragma mark - Helpers

- (void)showMenuController
{
  [self becomeFirstResponder];

  UIMenuController *sharedMenuController = [UIMenuController sharedMenuController];

  [sharedMenuController setTargetRect:CGRectMake(100, 100, 0, 0) inView:self.view];
  [sharedMenuController setMenuVisible:YES animated:YES];
}

#pragma mark - Main

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [self showMenuController];
}

- (BOOL)canBecomeFirstResponder
{
  return YES;
}

#pragma mark - Actions

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
  if (action == @selector(cut:) || action == @selector(copy:)) return YES;
  return NO;
}

- (void)cut:(id)sender { NSLog(@"cut"); }
- (void)copy:(id)sender { NSLog(@"copy"); }

@end
```
