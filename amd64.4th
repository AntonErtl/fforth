\ AMD64-specific native-code generation routines on AMD64

: !branch ( addr1 addr2 -- )
    \ let branch ending at addr2 jump to addr1; AMD64 branches end
    \ with 4-byte relative addresses.
    dup >r - r> 4 - l! ;

: literal ( x -- )
    ]] lit [[ chere cell- ! ;
