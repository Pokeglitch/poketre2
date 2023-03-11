macro Interface@lambda
    for i, 2, _narg
        def \1@\<i> equs \<_NARG>
        def \1@\<i>#isLambda = true
        ; Add the lambda to the list of lambdas
        append \1#Lambdas, \<i>
    endr
endm

macro Interface@lambda#assign
    if def(\2@method)
        for i, 4, _narg+1
            def \@#continue equs "Interface@lambda#assign#final \3@\<i>,"
            Interface@continue \2@method, \@#continue, \1, \<i>
        endr
    endc
endm

macro Interface@lambda#assign#final
    redef \2 equs "\1"
endm
