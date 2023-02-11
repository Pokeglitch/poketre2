Scope Overload
    init
        def {self}StartIndex = {\1}
        def {self}EndIndex = {\1}
        def {self}Name equs "\1"
        def {self}#isPassthrough = true
    endm

    local overload
    func
        enter Overload, {{self}Name}
    endm

    local skip
    func
        def {{self}Name} += \1
    endm

    local next
    func
        if {{self}Name} > {self}EndIndex
            def {self}EndIndex = {{self}Name}
        endc
        def {{self}Name} = {self}StartIndex
    endm

    final
        if {{self}Name} < {self}EndIndex
            def {{self}Name} = {self}EndIndex
        endc
    endm
end