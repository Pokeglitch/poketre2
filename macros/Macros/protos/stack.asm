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
    def \1#size = 0
    def \1@push equs "__Stack@push \1,"
    def \1@pop equs "__Stack@pop \1,"
    
    ; Initialize the base value to be empty
    def \1#0 equs ""

    ; Initialize the symbol
    def \1 equs "\{\1#\{d:\1#size}}"

    ; initialize if provided arguments
    if _narg > 1
        def \@#symbol equs "\1"
        shift
        {\@#symbol}@push \#
    endc
endm

macro __Stack@push
    ; Store the current element as the parent
    def \@#parent equs "{\1#{d:\1#size}}"

    ; increase the size
    def \1#size += 1

    ; create a unique id for the new stack element
    uuid \1#{d:\1#size}

    ; map the parent, index, and ID
    def {id}#Parent equs "{\@#parent}"
    def {id}#Index = \1#size
    def {id}#ID equs "{id}"

    def \@#symbol equs "\1"
    shift
    {\@#symbol}@init {id}, \#
endm

macro __Stack@pop
    if \1#size
        def \1#size -= 1
    else
        fail "\1 is empty"
    endc
endm
