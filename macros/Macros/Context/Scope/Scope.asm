Context Scope
    exit
        DefineContextMacro {\1#Methods}
        DefineContextMacro {\1#Functions}
    endm

    method
        continue {\1#Name}_\2
    endm

    property
        continue \1#\2
    endm

    handle
        def \@#context equs "\1"
        shift 4

        continue {\@#context}, \#
    endm
end
