    include "macros/Macros/stack.asm"
    include "macros/Macros/base.asm"
    incDir macros/Macros/library, overload, context, scope




Scope Person
    init
        def {self}FirstName equs "\1"
        say Hello
    endm

    local say
    func
        msg {{self}FirstName} says \1
    endm

    local birth
    func
        enter Person, \1
    endm

    from Person
    func
        say See ya later!
    endm

    final
        say Goodbye
    endm
end

    enter Person, Joe
        say I exist!
        birth Harry
            say Are you my mommy {{{self}#Parent}FirstName}?
        exit
        birth Sally
            birth Fred
                say {{{{self}#Parent}#Parent}FirstName} is my grandpa!
            exit
        exit
    exit