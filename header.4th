\ fforth word header

\ The word header has fields for various purposes, in particular
\ method xts for several words that operate on words (represented by
\ nts or xts).  For a long discussion of the topic, read [paysan19].

\ @InProceedings{paysan19,
\   author =       {Bernd Paysan and M. Anton Ertl},
\   title =        {The new {Gforth} Header},
\   crossref =     {euroforth19},
\   pages =        {5--20},
\   url =          {http://www.euroforth.org/ef19/papers/paysan.pdf},
\   url-slides =   {http://www.euroforth.org/ef19/papers/paysan-slides.pdf},
\   video =        {https://wiki.forth-ev.de/doku.php/events:ef2019:header},
\   OPTnote =      {refereed},
\   abstract =     {The new Gforth header is designed to directly
\                   implement the requirements of Forth-94 and
\                   Forth-2012.  Every header is an object with a fixed
\                   set of fields (code, parameter, count, name, link)
\                   and methods (\texttt{execute}, \texttt{compile,},
\                   \texttt{(to)}, \texttt{defer@}, \texttt{does},
\                   \texttt{name>interpret}, \texttt{name>compile},
\                   \texttt{name>string}, \texttt{name>link}).  The
\                   implementation of each method can be changed
\                   per-word (prototype-based object-oriented
\                   programming).  We demonstrate how to use these
\                   features to implement optimization of constants,
\                   \texttt{fvalue}, \texttt{defer}, \texttt{immediate},
\                   \texttt{to} and other dual-semantics words, and
\                   \texttt{synonym}.}
\ }
\ @Proceedings{euroforth19,
\   title = 	 {35th EuroForth Conference},
\   booktitle = 	 {35th EuroForth Conference},
\   year = 	 {2019},
\   key =		 {EuroForth'19},
\   url =          {http://www.euroforth.org/ef19/papers/proceedings.pdf}
\ }

\ name string
-9 cells
field: >count          \ length of the name
field: >link           \ address of previous word in wordlist
method: compile,       ( xt -- )          \ standard word
method: (to)           ( val xt -- )      \ used by TO
method: name>interpret ( nt -- xt )       \ standard word
method: name>compile   ( nt -- xt1 xt2 )  \ standard word
method: does           ( ... body -- ... ) \ used by DOES> 
field: >cfa            \ code field; used by EXECUTE and DODEFER
field: >body           \ =nt=xt; parameter field
drop
