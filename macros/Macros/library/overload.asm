
    Stack Overload

macro Define_Overload
    def \1StartIndex = {\2}
    def \1EndIndex = {\2}
    def \1Name equs "\2"
endm

macro Overload_overload
    Push_Overload {{Overload}Name}
    SetContext Overload
endm

macro Overload_skip
    DEF {{Overload}Name} += \1
endm

macro Overload_next
    if {{Overload}Name} > {Overload}EndIndex
        def {Overload}EndIndex = {{Overload}Name}
    endc
    def {{Overload}Name} = {Overload}StartIndex
endm

macro Overload_EndDefinition
    if {{Overload}Name} < {Overload}EndIndex
        def {{Overload}Name} = {Overload}EndIndex
    endc

    Pop_Overload
    CloseContext
endm

macro NewOverload
    Push_Overload \1
    shift
    SetContext Overload, \#
endm
