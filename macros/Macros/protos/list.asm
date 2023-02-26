;   A List is a string of comma separated values
def List equs "\tListDefinition"

macro ListDefinition
    redef \1 equs ""
    redef \1@push equs "List@push \1,"
    redef \1@contains equs "List@contains \{\1},"
endm

/*  To add the given values to the end of the given List
    \1  - List Symbol
    \2+ - Values to add    */
macro List@push
    if _narg == 2
        if strlen("{\1}")
            redef \1 equs "{\1},\2"
        else
            redef \1 equs "\2"
        endc
    else
        foreach 1, List@push, \#
    endc
endm

/*  To see if the given value exists in the given list
    \1+ - List elements
    \_NARG - Value to search for    */
macro List@contains
    result false
    for i, 1, _narg
        if strcmp("\<{d:_NARG}>","\<{d:i}>") == 0
            result true
            break
        endc
    endr
endm
