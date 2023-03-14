/*
    Define a property for this Interface
    \1 - Interface Name
    \2 - Property Initialization Method
    \3 - Property Name
    \4+? - Arguments to forward to Initialization Method
*/
macro Interface@property
    def \@#obj equs "\1#Properties#\3"

    ; Add the property ID to the list of properties
    append \1#Properties, \3

    ; Map the property information to a unique identifier
    def \1#Properties#\3#macro equs "\2"
    def \1#Properties#\3#name equs "\3"
    shift 3
    def {\@#obj}#args equs "\#"
endm

macro Interface@property#inherit
    for i, 3, _narg+1
        if not def(\1#Properties#\<i>)
            def \1#Properties#\<i>#macro equs "{\2#Properties#\<i>#macro}"
            def \1#Properties#\<i>#name equs "{\2#Properties#\<i>#name}"
            def \1#Properties#\<i>#args equs "{\2#Properties#\<i>#args}"
            append \1#Properties, \<i>
        endc
    endr
endm

macro Interface@property#assign
    if def(\2@property)
        if _narg == 3
            def \@#macro equs "Interface@property#assign \#,"
            foreach \@#macro, {\3#Properties}
        else
            def \@#continue equs "Interface@property#assign#final \3#Properties#\4,"
            Interface@continue \2@property, \@#continue, \1, {\3#Properties#\4#name}
        endc
    endc
endm

macro Interface@property#assign#final
    \1#macro \2, {\1#args}
endm
