Type2 Number
    init
        if _narg == 2
            \1@redef \2
        else
            \1@redef 0
        endc

        def \1#Initial = \1
    endm

    method inc
    func
        def \1 += 1
    endm

    method dec
    func
        def \1 -= 1
    endm

    method reset
    func
        def \1 = \1#Initial
    endm

    method redef
    func
        def \1 = \2
    endm

    method add
    func
        def \1 += \2
    endm

    method sub
    func
        def \1 -= \2
    endm

    method negate
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
