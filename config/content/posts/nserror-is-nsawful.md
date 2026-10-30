---
date: "2010-10-14"
title: NSError is NSAwful
summary: "Cocoa appears to be missing a key component to programming: exceptions. In place of the standard try / catch / raise style of programming error objects are used."
tags:
  - ios
  - ipad
  - iphone
  - cocoa
  - apple
---

NSError is a contender for one of the worst features of the cocoa framework. Who thought these are these better than exceptions? Don't developers see that these are just fancy return codes? Here are some major problems:

1.  Most developers don't handle errors. Exceptions add pressure to not let things slip. With 'NSError' it is so easy to pass NULL or never check the return.
2.  Mobile devices don't have any easy way to display errors. Desktop applications have 'NSApp' that can present localized versions of errors, but what about iOS?
3.  Most documents don't detail what errors can occur. For example, the documentation for 'NSFetchedResultsController' states 'contains an error object that describes the problem'. Great.
