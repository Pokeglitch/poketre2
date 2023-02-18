Definition Struct
    exit
        try_purge func, init, final
    endm

    open
        def \2#isPassthrough = false
    endm

    handle
        def \@#macro equs "\2@\1"
        def \@#instance equs "\2"
        def \@#context equs "\4"
        
        shift 4
        \@#macro {{\@#context}#Symbol}, \#
    endm
end
