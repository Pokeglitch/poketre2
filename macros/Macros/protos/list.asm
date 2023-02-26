;   A List is a string of comma separated values
def List equs "\tList#Definition"

macro List#Definition
    String \1
    Number \1#_size

    redef \1@push equs "\tList@push \1,"
    redef \1@contains equs "\tList@contains \1,"

    for i, 2, _narg+1
        \1@push \<{d:i}>
    endr
endm

/*  To add the given values to the end of the given List
    \1  - List Symbol
    \2+ - Values to add    */
macro List@push
    if _narg == 2
        if \1#_len
            \1@add ","
        endc

        \1@add "\2"

        redef \1#{d:\1#_size} equs "\2"

        \1#_size@inc
    else
        foreach 1, List@push, \#
    endc
endm

macro List@contains
    result false
    for i, \1#_size
        if strcmp("{\1#{d:i}}","\2") == 0
            result true
            break
        endc
    endr
endm
