macro Super@init
    def \1#list equs "\2"
    ; start at the end of the list
    Number \1#index, \2#_size-1
endm

macro Super@find
    List \1, fail "super does not exit for this context"\n
    Super@find#loop \#
endm

macro Super@find#loop
    for i, 3, _narg+1
        Super@find#next \1, \2, \<i>
    endr
endm

macro Super@find#next
    ; store the macro name, since 'i' will change from call to Super@find#next
    def \@#macro equs "\3@\2"
    ; check the parents
    Super@find#loop \1, \2, {\3#_Inherits}

    ; if the macro name exists, add it to the list
    if def({\@#macro})
        \1@push {\@#macro}
    endc
endm

macro Super@execute
    def \@#macro equs "{{Super}#list}#{d:{Super}#index}"
    
    ; update next super call to refer to the previous super
    {Super}#index@dec

    \@#macro \#
    
    ; return the super call index
    {Super}#index@inc
endm

macro Super@handle#before
    def \@#macro equs "Super@handle#_before \#"
    Super@try \@#macro
endm

macro Super@handle#_before
    ; if the supers for this method have not been defined, then do so
    if !def(\1@\2#super)
        Super@find \1@\2#super, \2, {\1#_Inherits}
    endc

    Super@push \1@\2#super
endm

macro Super@try
    if Type#_Super#Ready
        Super@pause \1
    endc
endm

macro Super@pause
    def Type#_Super#Ready = false
    \1
    def Type#_Super#Ready = true
endm

macro Super@find_all_methods
    for i, 2, _narg+1
        Super@find \1@\<i>#super, \<i>, {\1#_Inherits}
    endr
endm

macro Super@find_all_types
    rept _narg
        Super@find_all_methods \1, {\1#_Methods}
        shift
    endr
endm

    Super@pause Stack Super