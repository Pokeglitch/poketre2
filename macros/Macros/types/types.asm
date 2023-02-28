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
    redef End#Definition equs "\tType#End \1,"

    def \@#symbol equs "\1"
    shift
    def {\@#symbol}#_Inherits equs "\#"
endm

macro Type#Initialize
    Type#InitializeParents \2, {\1#_Inherits}

    ; Assign the properties & methods
    Type#AssignProperties \2, {\1#_Properties}
    Type#AssignMethods \1, \2, {\1#_Methods}

    def \@#macro equs "\1#Initialize"
    shift
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
        redef \2@\<i> equs "Type#ExecuteMethod \1, \<i>, \2,"
    endr
endm


macro Super@init
    def \1#list equs "\2"
    ; start at the end of the list
    def \1#index = \2#_size-1
endm

macro Super@find
    List \1, fail "super does not exit for this context"\n
    Super@find#next \#
endm

macro Super@find#next
    for i, 3, _narg+1
        ; store the macro name, since 'i' will change from call to Super@find#next
        def \@#macro equs "\<i>@\2"
        ; check the parents
        Super@find#next \1, \2, {\<i>#_Inherits}

        ; if the macro name exists, add it to the list
        if def({\@#macro})
            \1@push {\@#macro}
        endc
    endr
endm

macro Super@handle
    def \@#macro equs "{{Super}#list}#{d:{Super}#index}"
    
    ; update next super call to refer to the previous super
    def {Super}#index -= 1

    \@#macro \#
    
    ; return the super call index
    def {Super}#index += 1
endm

def Type#_Super#Initialized = false
def Type#_Super#Ready = false
def super equs "fail \"super does not exit for this context\"\n"
; TODO - instead of these bools, redefine Type#ExecuteMethod??
macro Type#ExecuteMethod

    ; Initialize Super if it has not yet been initialized
    if !Type#_Super#Initialized
        def Type#_Super#Initialized = true
        Stack Super
        def Type#_Super#Ready = true
    endc

    def \@#prev_super equs "{super}"

    if Type#_Super#Ready
        def Type#_Super#Ready = false
        ; if the supers for this method have not been defined, then do so
        if !def(\1@\2#super)
            Super@find \1@\2#super, \2, {\1#_Inherits}
        endc
        
        Super@push \1@\2#super

        redef super equs "\tSuper@handle \3,"

        def Type#_Super#Ready = true
    endc

    def \@#macro equs "\1@\2"
    shift 2
    \@#macro \#

    if Type#_Super#Ready
        def Type#_Super#Ready = false
        Super@pop
        def Type#_Super#Ready = true
    endc
    redef super equs "{\@#prev_super}"
endm

macro Type#End
    def \1 equs "\tType#Initialize \1,"
    
    try_purge init, func, property, method, End#Definition
endm
