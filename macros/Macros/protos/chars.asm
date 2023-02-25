;   A Chars is a comma separated list of single characters
def Chars equs "\tCharsDefinition"

macro CharsDefinition
    def \1@startOf equs "Chars@startOf \1,"

    def \@#name equs "\1"
    shift
    def {\@#name} equs "\#"
endm

/*  To see if the given value starts with any of the characters in the given Chars
    \1 - Chars Symbol
    \2 - Value to check    */
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
