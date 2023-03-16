/*
    From methods get execute when returning to this Context from another Context with the given name(s)
    - can end with string to make lambda
    - otherwise, need to follow with 'args'
*/
macro Interface@from
    is#String \<_NARG>
    if so
        for i, 3, _narg
            def \2@from@\<i> equs "Interface@method#lambda \<_NARG>,"
            append \2#Functions, from@\<i>
        endr
    else
        redef temp@name equs "\2@\@"
        Interface@args \1, \2, {temp@name}
        for i, 3, _narg+1
            def \2@from@\<i> equs "Interface@method#execute \2@from@\<i>, {temp@name},"
            append \2#Functions, from@\<i>
        endr
    endc
endm

def From#Interface@method#lambda equs "Interface@method#lambda"

macro From#Interface@method#execute
    ; handle the closed scope so the argument matches what is expected
    if def({\7#Context}@handle)
        Interface@continue {\7#Context}@handle, {\3#Name}_from@{\7#Name}, \7,\4,\5,\6
    else
        {\3#Name}_from@{\7#Name} \3, \7
    endc
endm
