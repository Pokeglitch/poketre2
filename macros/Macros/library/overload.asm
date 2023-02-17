Scope Overload
    init
        def \1StartIndex = {\2}
        def \1EndIndex = {\2}
        def \1Name equs "\2"
    endm

    local overload
    func
        enter Overload, {\1Name}
    endm

    local skip
    func
        def {\1Name} += \2
    endm

    local next
    func
        if {\1Name} > \1EndIndex
            def \1EndIndex = {\1Name}
        endc
        def {\1Name} = \1StartIndex
    endm

    final
        if {\1Name} < \1EndIndex
            def {\1Name} = \1EndIndex
        endc
    endm
end