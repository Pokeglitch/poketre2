; Print given arguments on own line
macro msg
    rept _NARG
        print "\1\n"
        shift
    endr
endm

; Include given files in given directory
; \1  - Directory name
; \2+ - File name
macro incDir
    for i, 1, _NARG
        include "\1/\2.asm"
    endr
endm