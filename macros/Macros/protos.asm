def false equs "0"
def true equs "1"
def _narg equs "_NARG"


def List equs "\tListDefinition"

macro ListDefinition
    redef \1 equs ""
    redef \1@push equs "List@push \1,"
    redef \1@contains equs "List@contains \1,"
endm

macro List@push
    if _narg == 2
        if strlen("{\1}")
            redef \1 equs "{\1}, \2"
        else
            redef \1 equs "\2"
        endc
    else
        foreach 1, List@push, \#
    endc
endm

macro List@contains
    List@_contains \1@contains#result, \2, {\1}
endm

macro List@_contains
    def \1 = 0
    for i, 3, _narg+1
        if strcmp("\2","\<{d:i}>") == 0
            def \1 = 1
        endc
    endr
endm

def Chars equs "\tCharsDefinition"

macro CharsDefinition
    def \1@startOf equs "Chars@startOf \1,"

    def \@#name equs "\1"
    shift
    def {\@#name} equs "\#"
endm

macro Chars@startOf
    Chars@_atIndex 1, \1@startOf#result, \2, {\1}
endm

macro Chars@_atIndex
    def \2 = 0
    for i, 4, _narg+1
        if strin("\3","\<{d:i}>") == \1
            def \2 = 1
            break
        endc
    endr
endm

Chars Number#start_chars, 0,1,2,3,4,5,6,7,8,9,-,+,$,&,%,`

macro is#Number
    Number#start_chars@startOf \1
    result Number#start_chars@startOf#result
endm

; to mimic the functionality of return before it gets defined
macro result
    def so = \1
    def not = !(so) 
endm
