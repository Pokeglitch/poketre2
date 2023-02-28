; Basic implementation of data types to be used by methods before "Types" get defined
def false equs "0"
def true equs "1"

/*  To generate a unique id and assign to global 'id' symbol, and optionally, the provided argument
    \1? - Symbol to assign to    */
macro uuid
    redef id equs "\@"
    if _narg == 1
        redef \1 equs "\@"
    endc
endm

; To define so/not to be used in an if statement
; NOTE: cannot be nested
macro result
    def so = \1
    def not = !(so)
endm

define Type
func
    def \1#_Properties equs ""
    def \1#_Methods equs ""

    disposable init, \1#Initialize
    redef property equs "\tType#Property \1,"
    redef method equs "\tType#Method \1,"
    redef End#Definition equs "\tType#End \#,"
endm

macro Type#Initialize
    Type#InitializeParents \3, {\2}

    ; Assign the properties & methods
    Type#AssignProperties \3, {\1#_Properties}
    Type#AssignMethods \1, \3, {\1#_Methods}

    def \@#macro equs "\1#Initialize"
    shift 2
    try_exec {\@#macro}, \#
endm

macro Type#InitializeParents
    for i, 2, _narg+1
        \<i> \1
    endr
endm

macro Type#Property
    def \@#macro equs "\2"
    def \@#symbol equs "\3"
    append \1#_Properties, \@
endm

macro Type#AssignProperties
    for i, 2, _narg+1
        \<i>#macro \1#{\<i>#symbol}
    endr
endm

macro Type#Method
    disposable func, \1@\2
    append \1#_Methods, \2
endm

macro Type#AssignMethods
    for i, 3, _narg+1
        redef \2@\<i> equs "\1@\<i> \2,"
    endr
endm

macro Type#End
    def \@#symbol equs "\1"
    shift
    def \@#parents equs "\#"
    def {\@#symbol} equs "\tType#Initialize  {\@#symbol}, \@#parents,"
    
    try_purge init, func, property, method, End#Definition
endm
