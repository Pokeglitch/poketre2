/*
A vector is a set of elements, not meant to be forwarded as arguments
*/
macro Vector
    def \1#size = 0

    def \1@push equs "Vector@push \1,"
    def \1@contains equs "Vector@contains \1,"
endm

macro Vector@push
    if _narg == 2
        def \1#{d:\1#size} equs "\2"
        def \1#size += 1
    else
        foreach 1, Vector@push, \#
    endc
endm

macro Vector@contains
    result false
    for i, \1#size
        if strcmp("{\1#{d:i}}","\2") == 0
            result true
            break
        endc
    endr
endm