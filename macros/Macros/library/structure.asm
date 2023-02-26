Definition Struct
    exit
        DefineContextMacro {\1#Methods}
    endm

    open
        def \1#Symbol equs "\5"
        def \1#isPassthrough = false

        continue \#
    endm

    method
        continue {\1#Name}_\2
    endm

    property
        continue {\1#Symbol}#\2
    endm

    handle
        def \@#context equs "\1"
        shift 4

        continue {{\@#context}#Symbol}, \#
    endm
end
