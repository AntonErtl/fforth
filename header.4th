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


header-size negate
\ the name string is before the rest of the header, in conventional order
field: >count          \ length of the name
field: >link           \ address of previous word in wordlist

field: >compile,       \ xt1 ( xt -- )
\ This field contains xt1; by EXECUTEing it you COMPILE, the word this
\ header belongs to; you pass the xt of the word to COMPILE, so that
\ xt1 can be generic for a whole class of words.

field: >(to) \ xt2 ( val xt -- )
\ By EXECUTEing xt2 you store val in the memory associated with the
\ present word (xt); e.g. if xt is a VALUE, it would store val in the
\ body.  In standard terms, this is useful for implementing "TO name"
\ semantics.

field: >name>interpret \ xt3 ( nt -- xt )
\ By EXECUTEing xt3 you perform NAME>INTERPRET.  In the usual case,
\ this does nothing, because nt=xt, but if nt belongs to a synonym, it
\ gets from the synonym to the xt of the original.

field: >name>compile \ xt4 ( nt -- x xt )
\ By EXECUTEing xt4 you perform NAME>COMPILE.  For normal words, x=nt
\ and xt is `COMPILE,; immediate words are similar, but with
\ xt=`EXECUTE.  If you want to implement FIND, you are limited to
\ that.  But if you don't you are free to return any pair of x and xt
\ that makes sense.

field: >does \ xt5 ( ... body -- ... )
\ A SET-DOES>-defined word first pushes the body address of the word
\ on the stack, then EXECUTEs xt5.  For words that are not
\ SET-DOES>-defined, this field can be used for other purposes.

field: >cfa \ code field
\ This field contains the (native) code address that EXECUTE jumps to
\ for performing this word (with the body=xt=nt being in the wa
\ register).  Note that COMPILE,d code does not use the code field to
\ determine what to do; the exceptions are the code compiled for
\ EXECUTE (which uses the code field of the passed xt), the code
\ compiled for DEFERred words (which uses the code field of the word
\ that the deferred word performs), and theoretically all the words
\ with GENERAL-COMPILE, as their COMPILE, method (in practice, I
\ expect that all words get more specific COMPILE, methods that do not
\ need the code field of the word).

\ You may wonder why this native code compiler has a code field when
\ some others have not.  One reason is that the native code of a colon
\ definitions does not live in its parameter field, but somewhere in
\ the code section.  Another reason is that this allows for uniform
\ treatment of colon definitions and other kinds of words (other
\ systems have a jump or call at the start of non-colon-definitions).

field: >body \ =nt=xt
\ The body or parameter field contains data that is word-class
\ specific.  E.g., for a constant it contains the value of the
\ constant.  For a CREATEd word this is the address that the word
\ returns.

\ In Fforth, the body is also used as xt (always) and nt (usually, see
\ also >NAME>INTERPRET above).

drop

: compile, ( xt -- )
    dup >compile, @ execute ;

: set-optimizer ( xt -- )
    latest >compile, ! ;

\ Not needed (yet):
\ : (to) ( val xt -- )
\     dup >(to) @ execute ;
\ 
\ : set-to ( xt -- )
\     latest >(to) ! ;

: name>interpret ( nt -- xt )
    dup >name>interpret @ execute ;

: set->int ( xt -- )
    latest >name>interpret ! ;

: name>compile ( nt -- xt1 xt2 )
    dup >name>compile @ execute ;

: set->int ( xt -- )
    latest >name>compile ! ;

: general-compile, ( xt -- )
    \ this compile, implementation works for all word types, but is inefficient
    ]] literal execute [[ ;

: set-execute ( code-address -- )
    `general-compile, set-optimizer
    latest >cfa ! ;

variable last \ contains address of most recently defined word
variable current \ 


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
    `general-compile, , \ compile, (no default)
    `abort , \ (to) 
    `noop , \ name>interpret
    `default-name>comp , \ name>compile
    0 , \ does/extra
    0 , \ cfa
    here last ! ;

: make-word ( xt-compile code-address "name" -- )
    parse-name make-header
    latest >cfa !
    set-optimizer
    reveal ;

: lit, ( xt -- )
    ]] literal [[ ;

: create ( "name" -- )
    `lit, `dovar make-word ;

: compile,-constant ( xt -- )
    @ lit, ;

: constant ( x "name" -- )
    `compile,-constant `docon make-word ;

    



