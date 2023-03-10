/*
    From methods get execute when returning to this Context from another Context with the given name(s)
    - can end with string to make lambda
    - otherwise, need to follow with 'func'
*/
macro Interface@from
    is#String \<_NARG>
    if so
        redef temp@macro equs \<_NARG>
    else
        redef temp@name equs "\2@from@\<_NARG>#Definition"

        Interface@func \1, \2, {temp@name}

        redef temp@macro equs "Interface@from#execute \2@from@\<_NARG>,"
        Interface@from#define \2, from@\<_NARG>, temp@macro
    endc

    for i, 3, _narg
        Interface@from#define \2, from@\<i>, temp@macro
    endr
endm

macro Interface@from#define
    def \1@\2 equs "{\3}"
    append \1#Froms, \2
endm

macro Interface@from#execute
    def \@#prev_super equs "{super}"
    redef super equs "{\1#Super} \2, \3,"
    exec \1#Definition, \2, \3
    redef super equs "{\@#prev_super}"
endm

macro Interface@from#inherit
    for i, 4, _narg+1
        ; if not defined in this type, pull from parent
        if not def(\2@\<i>)
            Interface@from#inherit#define \2@\<i>, \1, \3, \<i>

            redef \2@\<i>#Super equs "{\3@\<i>#Super}"
            redef \2@\<i>#isSuper = true
            
            append \2#Froms, \<i>
        ; otherwise, the super is the parent
        else
            Interface@from#inherit#define \2@\<i>#Super, \1, \3, \<i>
            redef \2@\<i>#isSuper = false
        endc
    endr
endm
/*
    \1 - Symbol to assign to
    \2 - Context
    \3 - Parent Interface
    \4 - Method
*/
macro Interface@from#inherit#define
    redef \1 equs "{\3@\4}"
endm
