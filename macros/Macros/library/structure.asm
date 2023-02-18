Definition Struct
    exit
        ; todo - not necessary when using Context@SingleUse
        try_purge func, init, final
    endm

    open
        def \1#Symbol equs "\5"
        def \1#isPassthrough = false

        def \@#macro equs "\3@\4"
        shift 4
        try_exec {\@#macro}, \#
    endm

    handle
        def \@#context equs "\1"
        def \@#macro equs "\3@\4"
        shift 4
        try_exec {\@#macro}, {{\@#context}#Symbol}, \#
    endm
end
