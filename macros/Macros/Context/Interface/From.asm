/*
    From methods get execute when returning to this Context from another Context with the given name(s)
    - can end with string to make lambda
    - otherwise, need to follow with 'args'
*/
macro Interface@from
    is#String \<_NARG>
    if so
        for i, 3, _narg
            def \2@from@\<i> equs "Interface@function#lambda \<_NARG>,"
            append \2#Functions, from@\<i>
        endr
    else
        redef temp@name equs "\2@\@"
        Interface@args \1, \2, {temp@name}
        for i, 3, _narg+1
            def \2@from@\<i> equs "Interface@function#execute \2@from@\<i>, {temp@name}," ;"Interface@from#execute \2@from@\<i>, {temp@name},"
            append \2#Functions, from@\<i>
        endr
    endc
endm

def From#Interface@function#lambda equs "Interface@function#lambda"

macro From#Interface@function#execute
    ; handle the closed scope so the argument matches what is expected
    if def(\4@handle)
        Interface@continue \4@handle, {\3#Name}_from@{\7#Name}, \7,\4,\5,\6
    else
        {\3#Name}_from@{\7#Name} \3, \7
    endc
endm
