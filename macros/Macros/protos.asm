; Basic implementation of data types to be used by methods before "Types" get defined

def false equs "0"
def true equs "1"
def _narg equs "_NARG"

/*  To generate a unique id and assign to global 'id' symbol, and optionally, the provided argument
    \1? - Symbol to assign to    */
macro uuid
    redef id equs "\@"
    if _narg
        redef \1 equs "\@"
    endc
endm

; To mimic the functionality of "return" before it gets defined
macro result
    def so = \1
    def not = !(so)
endm

include "macros/Macros/protos/number.asm"
include "macros/Macros/protos/string.asm"
include "macros/Macros/protos/list.asm"
include "macros/Macros/protos/stack.asm"

/*  To check if the given value is a number
    \1 - Value to check    */
macro is#Number
    String@startswith \1, 0,1,2,3,4,5,6,7,8,9,-,+,$,&,%,`
endm
