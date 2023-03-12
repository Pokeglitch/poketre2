def self equs "fail \"self does not exist for this context\"\n"

Context Type
    open
        def \1#Symbol equs "\5"
        def \1#Type equs "\3"

        ; remove Symbol from forward to Instance Init
        def \@#args equs "\1, \2, \3, \4"
        shift 5
        continue {\@#args}, \#

        ; auto close the context
        end
    endm

    function
        continue {\1#Symbol}@\2
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
