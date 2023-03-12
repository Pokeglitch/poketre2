Scope Overload
    init
        def \1#StartIndex = {\2}
        def \1#EndIndex = {\2}
        def \1#Symbol equs "\2"
    endm

    function overload
    func
        Overload {\1#Symbol}
    endm

    function skip
    func
        def {\1#Symbol} += \2
    endm

    ; Update the EndIndex to match the Symbol if Symbol is greater
    function next
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
