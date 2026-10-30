---
date: "2014-05-21"
title: Using Timestamps for Caching on iOS or Mac
summary: A simple example of using timestamps to ensure users always see the latest data in an iOS or Mac app.
---

When serializing objects from a remote API it is a good idea to include `created_at` and `updated_at` timestamps. This helps enables the remote API to perform aggressive caching with little impact on the clients even when persisting objects (and when local persistent stores are used to cache objects). This short category demos a good method for ensuring a local client always has the perceived freshest copy of every object.

```objc
//  NSObject+KSStale.h

@interface NSObject (KSStale)

- (BOOL)KS_stale:(NSDictionary *)attributes;
- (BOOL)KS_fresh:(NSDictionary *)attributes;

@end
```

```objc
//  NSObject+KSStale.m

@implementation NSObject (KSStale)

- (BOOL)KS_stale:(NSDictionary *)attributes
{
  static NSString * const kCreatedAt = @"created_at";
  static NSString * const kUpdatedAt = @"updated_at";
  static NSDateFormatter * const isoDateFormatter = [[NSDateFormatter alloc] init];

  SEL getCreatedAtSelector = @selector(createdAt);
  SEL getUpdatedAtSelector = @selector(updatedAt);

  NSDate *currentCreatedAt = nil;
  NSDate *currentUpdatedAt = nil;
  NSDate *modifiedCreatedAt = nil;
  NSDate *modifiedUpdatedAt = nil;

  if ([self respondsToSelector:getCreatedAtSelector])
    currentCreatedAt = [self performSelector:getCreatedAtSelector];
  if ([self respondsToSelector:getUpdatedAtSelector])
    currentUpdatedAt = [self performSelector:getUpdatedAtSelector];

  if (attributes[kCreatedAt])
    modifiedCreatedAt = [isoDateFormatter dateFromString:attributes[kCreatedAt]];

  if (attributes[kUpdatedAt])
    modifiedUpdatedAt = [isoDateFormatter dateFromString:attributes[kUpdatedAt]];

  return !currentUpdatedAt || !currentCreatedAt || !modifiedUpdatedAt || !modifiedCreatedAt ||
        [currentUpdatedAt compare:modifiedUpdatedAt] == NSOrderedAscending || [currentCreatedAt compare:modifiedCreatedAt] == NSOrderedAscending;
}

- (BOOL)KS_fresh:(NSDictionary *)attributes
{
    return ![self KS_stale:attributes];
}

@end
```

```objc
//  KSBook.m

#import "NSObject+KSStale.h"

@implementation KSBook

- (void)deserialize:(NSDictionary *)attributes
{
  static NSDateFormatter * const isoDateFormatter = [[NSDateFormatter alloc] init];

  if ([self KS_stale:attributes])
  {
    self.title = attributes[@"title"];
    self.createdAt = [isoDateFormatter dateFromString:attributes[@"created_at"]];
    self.updatedAt = [isoDateFormatter dateFromString:attributes[@"updated_at"]];
    [self save];
  }
}

@end
```
