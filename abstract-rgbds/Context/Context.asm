/*  A Context creates a new Trace Type
    Then, this Context can be used to create new Interfaces
    Finally, an Interface can entered/exited throughout the source

    The following macros can be are utilized by a Context:
        - (any can also be skipped)

    new: run when a new Interface of this Context is initialized
        \1   - Interface Name
        \2+? - Additional arguments 

    finish: run when a new Interface definition of this Context is exited
        \1 - Interface Name
        \2+? - Additional arguments

    open: run when an Interface is opened
        \1 - Trace
        \2 - Context Name
        \3 - Interface Name
        \4 - Method Name (init)
        \5+? - Additional arguments

        To execute the Interface "init" method:
        - continue \#

    close: run when an Interface is closed
        \1 - Trace
        \2 - Context Name
        \3 - Interface Name
        \4 - Method Name (init)
        \5+? - Additional arguments

        To execute the Interface "exit" method:
        - continue \#


    Methods within an Interface

    forward: Macro to permit access through isolation
*/

/*
    \1 - Context Name
*/
method Context
  args
    ; Push context so cant write to ROM
    pushs
    Trace@Open Context

    ; Enable Isolate
    def {Trace}#Isolate = true

    ; Define the single use macro names
    Trace@Disposables \1, new, finish, open, method, property, handle, close

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
