---
date: "2010-03-11"
title: A Few Reasons Cocoa Is Not That Hot
summary: Over the past year Apple has released an amazing set of phones and tablets. While the devices are incredible the framework and language  have a few shortcomings that Apple will have to address.
tags:
  - ios
  - ipad
  - iphone
  - cocoa
  - apple
---

Over the past half-year I have been developing software for the iOS (both iPhone and iPad). Although Cocoa is excellent overall, a few rough edges prevent it from being the truly great experience:

# The Language

Objective-C is the language of choice for most Cocoa developers (the framework can be accessed through bridges with Ruby or Python the vast majority of Cocoa programmers use Objective-C). It provides a layer on top of the C program language that adds in support for dynamic typing and messaging.

While the language grows on programers over time it suffers from a few short comings:

1. The language has no form of automated memory management (garbage collection) and forces users to handle memory using retain and release counts.
2. The language splits primitives and objects in strange places (NSString and string, NSNumber and int, NSArray and [], and many more).
3. The language does not offer proper name spacing and instead relies on prefixing declarations (NS, UI, CA, and many more).

# The Controls

Interface builder is one of the best GUI designers available. That said, the iPhone and iPad controls are not nearly as verbose as the Mac desktop application controls. The lack of support for grids, checkboxes, color pickers, and even good looking buttons can be frustrating. It is obvious that Apple had to exclude tools that will not work on the mobile platform, but their UI kit might be a bit too limited.

Although Cocoa offers great customization of controls, developers must revert to code to get certain core features working. A great example is creating form elements within a table (something done in thousands of applications, including the 'Settings' app). Developers will need to setup delegates, protocols, and data-structures for something that should be drag-and-drop. For static forms, this is wasteful and time consuming.

# The Ecosystem

One of the largest shortcomings of iOS development is the lack of a package manager. Installing a new framework often involves 10-20 step guides and customizing strange compiler settings. A package manager similar to Bundler for Ruby could go a very long way in helping developers integrate third party frameworks.

# Conclusion

I am hopeful that Apple will continuously upgrade the languages and frameworks provided Mac and iOS development. I question the decision to use a 25 years old language on brand new mobile devices and hope that with framework improvements new languages will be unlocked for iOS in the future.
