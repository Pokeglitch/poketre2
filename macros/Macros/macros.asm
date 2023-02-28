    include "macros/Macros/base.asm"
    
incdir types, number, string, list, stack, super

Type Double, Number
    method inc
    func
        super
        \1@add 1
    endm

    method add
    func
        super \2
        super \2
    endm
end

Type Quad, Double
    method inc
    func
        super
        \1@add 1
    endm

    method add
    func
        super \2
        super \2
    endm
end

    Quad Test
    msg {Test}
    Test@inc
    msg {Test}

    include "macros/Macros/library/context.asm"
    include "macros/Macros/library/definition.asm"
    include "macros/Macros/library/return.asm"
    include "macros/Macros/definitions/struct.asm"
    include "macros/Macros/definitions/scope.asm"
