# Fforth

Fforth in not yet in a usable state.

Fforth is a minmalist modern Forth implementation.  It is a 64-bit
native-code Forth system running on AMD64 (porting to other
architectures should be easy).  

The main goal of Fforth is to demonstrate modern Forth implementation
techniques, in particular

* header structures that directly represent, e.g., compilation
semantics

* recognizers

While these techniques are demonstrated in Gforth, Gforth is complex
(due to being featureful and portable), and is a moving target (not so
great for basing educational material on it).  The idea is that Fforth
is for modern Forth what eforth or fig-Forth are for old-fashioned
Forth.

So the goals of Fforth are

* clarity of exposition

* simplicity (which helps clarity)

Non-goals are:

* minimal memory use

* Performance (Fforth uses native code to demonstrate that, not for
  performance reasons).

Concerning standard conformance, if Fforth implements a word that has
the name of a standard word, that word also has the standardized
behaviour.  But it is not a goal to implement all core words.

Fforth is free software, licensed under GPLv3.  Some of its code is
based on Gforth.

### About the name

The name was chosen because Fforth is intended to be more modern than
eforth, and simpler than Gforth (or approximately as simple as eforth
and at least as modern as Gforth).

There have been at least two other systems with a conflicting name.
Marcel Hendrix called his first system FForth
<[67916db8-89d5-415f-8b77-d453536ca393n@googlegroups.com](http://al.howardknight.net/?ID=163195341400)>;
and David Given has published [fforth](http://cowlark.com/fforth/).
You can differentiate Fforth from FForth and fforth by the
capitalization (in prose; on case-sensitive file systems directories
and executables are called 'fforth').
