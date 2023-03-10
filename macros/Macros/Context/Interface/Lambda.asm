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
        if _narg == 3
            def \@#macro equs "Interface@lambda#assign \#,"
            foreach \@#macro, {\3#Lambdas}
        else
            def \@#args equs "\#"
            def \@#continue equs "Interface@lambda#assign#final \3@\4,"
            
            Interface@continue \2@method, \@#continue, \1, \4
        endc
    endc
endm

macro Interface@lambda#assign#final
    redef \2 equs "\1"
endm
