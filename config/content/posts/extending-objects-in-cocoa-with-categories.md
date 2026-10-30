---
date: "2010-03-24"
title: Extending Objects in Cocoa with Categories
summary: Adding in functionality to an existing class in Cocoa is easy using categories. This can be useful for methods that should be transient or when access to the original code is restricted.
tags:
  - ios
  - mac
  - iphone
  - ipad
  - cocoa
---

Cocoa categories provide a great way to modify existing classes with additional functionality. Here is a good example of extensions in action:

**NSDate+Accessors.h**

```objc
//
//  NSDate+Accessors.h
//  Illustrate
//
//  Created by Kevin Sylvestre on 10-03-24.
//  Copyright 2010 Kevin Sylvestre. All rights reserved.
//

@interface NSDate (Accessors)

@property (nonatomic, retain, readonly) NSString *distance;

@end
```

**NSDate+Accessors.m**

```objc

//
//  NSDate+Accessors.m
//  Illustrate
//
//  Created by Kevin Sylvestre on 10-03-24.
//  Copyright 2010 Kevin Sylvestre. All rights reserved.
//

#import "NSDate+Accessors.h"

@implementation NSDate (Accessors)

# define SINGULAR (1)

- (NSString *)distance
{
  // Load interval.
  NSTimeInterval interval = [self timeIntervalSinceNow];

  // Calculate interval.
  NSInteger seconds = round(abs(interval));
  NSInteger minutes = round(abs(interval) / 60);
  NSInteger hours   = round(abs(interval) / 3600);
  NSInteger days    = round(abs(interval) / 86400);
  NSInteger weeks   = round(abs(interval) / 604800);
  NSInteger months  = round(abs(interval) / 2629743);
  NSInteger years   = round(abs(interval) / 31556926);

  // Calculate direction.
  NSString *direction;
  if (interval &gt; 0) direction = @"until";
  if (interval &lt; 0) direction = @"ago";

  // Create unit and amount.
  NSString *unit = nil;
  NSInteger amount;

  // Set unit and amount.
  if (interval == 0);
  else if (years)   { amount = years;   unit = amount == SINGULAR ? @"year"   : @"years";   }
  else if (months)  { amount = months;  unit = amount == SINGULAR ? @"month"  : @"months";  }
  else if (weeks)   { amount = weeks;   unit = amount == SINGULAR ? @"week"   : @"weeks";   }
  else if (days)    { amount = days;    unit = amount == SINGULAR ? @"day"    : @"days";    }
  else if (hours)   { amount = hours;   unit = amount == SINGULAR ? @"hour"   : @"hours";   }
  else if (minutes) { amount = minutes; unit = amount == SINGULAR ? @"minute" : @"minutes"; }
  else if (seconds) { amount = seconds; unit = amount == SINGULAR ? @"second" : @"seconds"; }
  else return @"now";

  // Format string and return.
  return [NSString stringWithFormat:@"%i %@ %@", amount, unit, direction];
}

@end
```

Accessing extensions is simple: just import the header file. In the case above, easily readable dates are now at the finger tips!
