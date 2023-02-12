    include "macros/Macros/stack.asm"
    include "macros/Macros/base.asm"
    incDir macros/Macros/library, context, types, scope, return, overload




    List Cards
    Cards@push Ace, King, Queen, Jack
    msg {Cards#2}
    Cards@pop -3, 2
    msg "{Cards#Size}: {Cards}"

    Cards@insert -1, Joker, Harry
    msg "{Cards#Size}: {Cards}"
    
    Cards@set 4, Joe
    msg "{Cards#Size}: {Cards}"


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