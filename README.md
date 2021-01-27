# fforth

Fforth in not yet in a usable state.

Fforth is a minmalist modern Forth implementation.  It is a 64-bit
native-code Forth system running on AMD64 (porting to other
architectures should be easy).  

The main goal of fforth is to demonstrate modern Forth implementation
techniques, in particular

* header structures that directly represent, e.g., compilation
semantics

* recognizers

While these techniques are demonstrated in Gforth, Gforth is complex
(due to being featureful and portable), and is a moving target (not so
great for basing educational material on it).  The idea is that fforth
is for modern Forth what eforth or fig-Forth are for old-fashioned
Forth.

So the goals of fforth are

* clarity of exposition

* simplicity (which helps clarity)

Non-goals are:

* minimal memory use

* Performance (fforth uses native code to demonstrate that, not for
  performance reasons).

Concerning standard conformance, if fforth implements a word that has
the name of a standard word, that word also has the standardized
behaviour.  But it is not a goal to implement all core words.

Fforth is free software, licensed under GPLv3.  Some of its code is
based on Gforth.
