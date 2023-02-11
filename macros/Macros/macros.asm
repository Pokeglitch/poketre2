    include "macros/Macros/stack.asm"
    include "macros/Macros/base.asm"
    incDir macros/Macros/library, context, types, scope, overload




Scope Person
    default run
    kill die

    init
        def {self}FirstName equs "\1"
        say Hello
    endm

    local say
    func
        ;msg {{self}FirstName} says \1
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

macro _run
    msg {{self}FirstName} is running!
endm

macro _die
    msg {{self}FirstName} died!
endm

    enter Person, Joe
        say I exist!
        birth Harry
            say Are you my mommy {{{self}#Parent}FirstName}?
        end
        
        run

        birth Sally
            birth Fred
                say {{{{self}#Parent}#Parent}FirstName} is my grandpa!
                die
            say I'm sad :(
        end
    end