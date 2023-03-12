/*
TODO:
    Get "super" working for From
        - Dont add From to froms list if already defined
NOTE: From wont trigger when returning from a Context that inherits from the context defined in the 'from' statement

--------
    Clean up how the init/exit supers get assigned

    - Finalize CheckReservedName and apply where necessary
        - can utilize Array@contains

    make a Register Type?
    Attach #RegisterSize = 6/12 to all registers
    - i.e. a#RegisterSize
    - use instead of isRegister macro (or, use in the isRegister macro and make that a return value)

    - Method can define arguments by name (get notes from Obsidian 3/1/23)
        - for 'func', first line after macro definition will assign the names to \@
        - plus, 'rest' for any extra
*/

/*  A Context creates a new Trace Type
    Then, this Context can be used to create new Interfaces
    Finally, an Interface can entered/exited throughout the source

    The following macros can be are utilized by a Context:
        - (any can also be skipped)

    init: run when a new Interface of this Type is initialized
        \1   - Interface Name
        \2+? - Additional arguments 

    exit: run when a new Interface of this Type is exited
        \1 - Interface Name
        \2+? - Additional arguments

    open: run when an Interface is opened
        \1 - Context
        \2 - Type Name
        \3 - Interface Name
        \4 - Method Name (init)
        \5+? - Additional arguments

        To execute the Interface "init" method:
        - continue \#

    close: run when an Interface is closed
        \1 - Context
        \2 - Type Name
        \3 - Interface Name
        \4 - Method Name (init)
        \5+? - Additional arguments

        To execute the Interface "exit" method:
        - continue \#


    Methods within an Interface

    forward: Macro to permit access through isolation
*/
def super equs "fail \"super does not exist for this context\"\n"

/*
    \1 - Context Name
*/
define Context
func
    ; Push context so cant write to ROM
    pushs
    Trace@Open Context

    ; Enable Isolate
    def {Trace}#Isolate = true

    ; Define the single use macro names
    Trace@Disposables \1, init, exit, open, function, property, handle, close

    ; update the Context End to include the Context Name
    redef Context_End#Definition equs "Context@end \1,"
endm

/*
    \1 - Type Name
*/
macro Context@end
    ; assign the Type Name to define an Interface of that Type
    def \1 equs "\tInterface@Define \1,"

    Trace@Close
    pops
endm

/*
    To try to execute a method assigned to the given Context
*/
macro Context@TryExec
    def \@#macro equs "\2@\1"
    shift 2
    try_exec {\@#macro}, \#
endm

incasm Trace
incdir Interface, Forward, From, Function, Property
incdir Scope, Overload, Return
incdir Struct, ByteStruct
incdir Type, Number, String, List, Stack
