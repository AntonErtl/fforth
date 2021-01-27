\ fforth word header

\ The word header has fields for various purposes, in particular
\ method xts for several words that operate on words (represented by
\ nts or xts).  For a long discussion of the topic, read:

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

9 cells constant header-size

\ name string
header-size negate
field: >count          \ length of the name
field: >link           \ address of previous word in wordlist
field: >compile,       \ xt ( xt -- )          \ standard word
field: >(to)           \ xt ( val xt -- )      \ used by TO
field: >name>interpret \ xt ( nt -- xt )       \ standard word
field: >name>compile   \ xt ( nt -- xt1 xt2 )  \ standard word
field: >does           \ xt? ( ... body -- ... ) \ used by DOES> 
field: >cfa            \ code field; used by EXECUTE and DODEFER
field: >body           \ =nt=xt; parameter field
drop

: compile, ( xt -- )
    dup >compile, @ execute ;

: (to) ( val xt -- )
    dup >(to) @ execute ;

: name>interpret ( nt -- xt )
    dup >name>interpret @ execute ;

: name>compile ( nt -- xt1 xt2 )
    dup >name>compile @ execute ;
    

variable last \ contains address of most recently defined word

: latest ( -- nt )
    last @ ;

: name>string ( nt -- c-addr u )
    >count dup @ tuck - swap ;

: .id ( nt -- )
    name>string type ;

: .word ( nt -- )
    >r
    "**********Name: " type r@ .id cr
    "  Code Address: " type r@ >cfa            @ hex. cr
    "    Link Field: " type r@ >link           @ hex. cr
    "      compile,: " type r@ >compile,       @ .id cr
    "          (to): " type r@ >(to)           @ .id cr
    "name>interpret: " type r@ >name>interpret @ .id cr
    "  name>compile: " type r@ >name>compile   @ .id cr
    "    does/extra: " type r@ >does           @ hex. cr
    r> drop ;

`compile, constant default-name>comp ( nt -- xt1 xt2 )
`execute constant immediate-name>comp ( nt -- xt1 xt2 )

: make-header ( c-addr u -- )
    align dup aligned over - allot tuck mem,
    , \ count
    0 , \ link
    0 , \ compile, (no default)
    `abort , \ (to) 
    `noop , \ name>interpret
    `default-name>comp , \ name>compile
    0 , \ does/extra
    0 , \ cfa
    here last ! ;

: compile,-create ( xt -- )
    \ compile, implementation for created words
    ]] literal [[ ;

: make-word ( xt-compile code-address "name" -- )
    parse-name make-header
    latest >cfa !
    latest >compile, !
    reveal ;

: create ( "name" -- )
    `compile,-create `dovar make-word ;

: compile,-constant ( xt -- )
    @ ]] literal [[ ;

: constant ( x "name" -- )
    `compile,-constant `docon make-word ;

    



