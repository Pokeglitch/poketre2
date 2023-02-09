; to send each argument to the given macro
macro foreach
    for i, 2, _NARG+1
        \1 \<i>
    endr
endm

; Print given arguments on own line
macro msg
    foreach _msg, \#
endm

macro _msg
    print "\1\n"
endm

; Include given files in given directory
; \1  - Directory name
; \2+ - File name
macro incDir
    for i, 2, _NARG+1
        include "\1/\<i>.asm"
    endr
endm