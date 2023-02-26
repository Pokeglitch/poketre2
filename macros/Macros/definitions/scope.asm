/*
TODO - add 'from' to handle when returning from another context
*/
Definition Scope
    exit
        ;msg b | "{\1#Methods}"
        DefineContextMacro {\1#Methods}
    endm

    method
        continue {\1#Name}_\2
    endm

    handle
        def \@#context equs "\1"
        shift 4

        continue {\@#context}, \#
    endm
end

Scope Overload
    init
        def \1#StartIndex = {\2}
        def \1#EndIndex = {\2}
        def \1#Symbol equs "\2"
    endm

    method overload
    func
        Overload {\1#Symbol}
    endm

    method skip
    func
        def {\1#Symbol} += \2
    endm

    ; Update the EndIndex to match the Symbol if Symbol is greater
    method next
    func
        if {\1#Symbol} > \1#EndIndex
            def \1#EndIndex = {\1#Symbol}
        endc
        def {\1#Symbol} = \1#StartIndex
    endm

    ; Update the Symbol to match the EndIndex if EndIndex is greater
    exit
        if  \1#EndIndex > {\1#Symbol}
            def {\1#Symbol} = \1#EndIndex
        endc
    endm
end

/*
    \1 - Symbol to store return value to
    \2 - if value is string or not
*/
Scope Return
    init
        def \1#ReturnUsed = false
        def \1#Symbol equs "\2"
        def \1#isString = \3
        if \3
            redef \1#Value equs ""
        else
            def \1#Value = 0
        endc
    endm

    method return
    func
        if \1#ReturnUsed
            fail "Already designated a return value"
        endc

        def \1#ReturnUsed = true

        if _narg > 1
            def \@#self equs "\1"

            ; if there is only 1 argument,
            ; and there is a ( that isnt at the beginning, then its macro call
            if _narg == 2 && strin("\2","(") > 1
                shift
                var_common {\@#self}#isString, "return \#", {\@#self}#Value=\#
            elif \1#isString
                shift
                ; can return multiple values if string
                redef {\@#self}#Value equs "\#"
            else
                def \1#Value = \2
            endc
        endc
    endm

    exit
        if \1#isString
            redef {\1#Symbol} equs "{\1#Value}"
        else
            def {\1#Symbol} = \1#Value
        endc
    endm
end
