\ primitives and native-code routines on AMD64

\ register usage:

\ rp  = rsp  return stack pointer
\ sp  = rbx  data stack pointer
\ tos = rax  top-of-stack
\ wa  = rsi  word address, contains xt when EXECUTEing a doer
\ temporary: rcx rdx rdi
\ unused: r8-r15; so porting to IA-32 should be easy
