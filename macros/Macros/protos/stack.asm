/*  A Stack is similar to a list, except it's interpreted value always represents the last element in the list
    The interprated value does not update when a push/pop is applied
    Instead, the interpreted value is itself an interpreted value, always referring to the last element when at time of interpretation

    Every stack element is actually a unique ID, and user assigns values to the stack element with a macro titles:
        {Stack Symbol}@init

    The first agument to this macro will be the UUID of the current stack element
    All subsequent arguments are forwarded from the @push macro
*/


/*  To define a Stack with the given symbol
    and optionally initialize it with provided arguments

    \1 - Stack Symbol
    \2+? - Optional arguments to initialize    */
macro __Stack
    Number \1#_size
    def \1@push equs "__Stack@push \1,"
    def \1@pop equs "__Stack@pop \1,"

    ; Initialize the symbol
    def \1 equs "\{\1#\{d:\1#_size}}"

    ; initialize if provided arguments
    if _narg > 1
        def \@#macro equs "\1@push"
        shift
        \@#macro \#
    endc
endm

macro __Stack@push
    ; generate a new uuid
    uuid

    ; map the parent to the id
    if \1#_size
        def {id}#_parent equs "{\1#{d:\1#_size}}"
    endc

    ; increase the size
    \1#_size@inc

    ; store id at the end of the stack
    redef \1#{d:\1#_size} equs "{id}"

    def \@#macro equs "\1@init"
    shift
    \@#macro {id}, \#
endm

macro __Stack@pop
    if \1#_size
        \1#_size@dec
    else
        fail "\1 is empty"
    endc
endm
