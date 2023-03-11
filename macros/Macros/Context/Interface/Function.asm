/*
    TODO - instead of following with func, follow with 'args'
*/
macro Interface@function
    is#String \<_NARG>
    if so
        for i, 3, _narg
            def \2@\<i> equs "Interface@function#lambda \<_NARG>,"
            append \2#Functions, \<i>
        endr
    else
        redef temp@name equs "\2@\@"
        Interface@func \1, \2, {temp@name}
        for i, 3, _narg+1
            def \2@\<i> equs "Interface@function#execute \2@\<i>, {temp@name},"
            append \2#Functions, \<i>
        endr
    endc
endm

/*
    \1 - Symbol to get super from
    \2 - Method to execute
    \3 - Context
    \4 - Type Name
    \5 - Interface Name
    \6 - Method Name
    \7+? - Arguments to forward to Method
*/
macro Interface@function#execute
    def \@#prev_super equs "{super}"
    
    redef \@#super equs "\1#Super"
    redef \@#macro equs "try_exec \2,"
    shift 2
    redef super equs "\@#super \1, \2, \3, \4,"

    if def(\2@handle)
        Interface@continue \2@handle, \@#macro, \#
    else
        shift 4
        \@#macro \#
    endc

    redef super equs "{\@#prev_super}"
endm

macro Interface@function#lambda
    def \@#macro equs \1
    shift 5
    \@#macro \#
endm

macro Interface@function#inherit
    for i, 4, _narg+1
        ; if not defined in this type, pull from parent
        if not def(\2@\<i>)
            redef \2@\<i> equs "{\3@\<i>}"
            redef \2@\<i>#Super equs "{\3@\<i>#Super}"
            append \2#Functions, \<i>
        ; otherwise, the super is the parent
        else
            redef \2@\<i>#Super equs "{\3@\<i>}"
        endc
    endr
endm

macro Interface@function#assign
    if def(\2@method)
        for i, 4, _narg+1
            def \@#continue equs "Interface@function#assign#final \1, \2, \3, \<i>,"
            Interface@continue \2@method, \@#continue, \1, \<i>
        endr
    endc
endm

macro Interface@function#assign#final
    redef \5 equs "{\3@\4} \1, \2, 3, \4,"
endm
