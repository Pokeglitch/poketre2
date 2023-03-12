Type Number
    init
        if _narg == 2
            \1@redef \2
        else
            \1@redef 0
        endc

        def \1#Initial = \1
    endm

    function inc
    func
        def \1 += 1
    endm

    function dec
    func
        def \1 -= 1
    endm

    function reset
    func
        def \1 = \1#Initial
    endm

    function redef
    func
        def \1 = \2
    endm

    function add
    func
        def \1 += \2
    endm

    function sub
    func
        def \1 -= \2
    endm

    function negate
    func
        redef \1 = -\1
    endm
end

/*  To check if the given value is a number
    \1 - Value to check    */
macro is#Number
    String \@#string, "\1"
    \@#string@startswith 0,1,2,3,4,5,6,7,8,9,-,+,$,&,%,`
endm
