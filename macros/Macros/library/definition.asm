/*
TODO:
    Can use super in macros to call parent function, even if UseSuper is false
    - can define super xx to allow UseSuper for explicit functions

    Should UseSuper be allowed in the member methods themselves?


    - Finalize CheckReservedName and apply where necessary
        - can utilize Array@contains

    - Method can define arguments by name (get notes from Obsidian 3/1/23)
        - for 'func', first line after macro definition will assign the names to \@
        - plus, 'rest' for any extra
*/

/*  A Definition creates a new Context Type
    Then, this Context Type can be used to create new Context Interfaces
    Finally, a Context Interface can entered/exited throughout the source

    The following macros can be are utilized by a Definition:
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

    lambda: An equs macro
        NOTE - must resolve to a macro
*/


/*
    \1 - Definition Type Name
*/
define Definition
func
    ; Push context so cant write to ROM
    pushs
    Context@Open Definition

    ; Disable UseSuper
    def {Context}#UseSuper = false

    ; Define the single use macro names
    Context@Disposables \1, init, exit, open, method, property, handle, close

    ; update the DefinitionType End to include the Definition Type Name
    redef Definition_End#Definition equs "DefinitionType@end \1,"
endm

/*
    \1 - Type Name
*/
macro DefinitionType@end
    ; assign the Type Name to define a Interface of that Type
    def \1 equs "\tInterface@Define \1,"

    Context@Close
    pops
endm

/*
    To try to execute a method assigned to the given Definition Type
    - Enables UseSuper before calling
        since this gets called inside the Interface context
*/
macro DefinitionType@TryExec
    def {Context}#UseSuper = true

    def \@#macro equs "\2@\1"
    shift 2
    try_exec {\@#macro}, \#

    def {Context}#UseSuper = false
endm

macro Interface@continue
    if def(\1)
        redef continue equs "\tdispose continue\n\t\2"
        def \@#macro equs "\1"
    else
        def \@#macro equs "\2"
    endc

    shift 2
    \@#macro \#
    try_purge continue
endm

macro Interface@func
    Context@Disposable func, \3
    redef func equs "\tInterface@SetMacros \1, \2\n{func}"
    dispose from, method, lambda, property, \1_End#Definition
endm


macro Interface@SetMacros
    ; update the from macro to include the name of the Interface
    redef from equs "Interface@from \1, \2,"

    ; update the method macro to include the name of the Interface
    redef method equs "Interface@method#define \1, \2,"

    ; update the method macro to include the name of the Interface
    redef lambda equs "Interface@lambda \2,"

    ; update the property macro to include the name of the Interface
    redef property equs "Interface@property \2,"

    ; update the end macro to include the name of the Interface
    redef \1_End#Definition equs "Interface@end \1, \2,"
endm

/*  To create a new Interface of a definition type
    \1 - Definition Type
    \2 - Interface Name
    \3+ - Arguments to pass to Definition Type Init Macro
*/
macro Interface@Define
    ; Push context so cant write to ROM
    pushs
    Context@Open \1

    Interface@SetMacros \1, \2

    ; Initialize the list of members
    List \2#Froms
    List \2#Lambdas
    List \2#Methods
    List \2#Properties
    
    ; Define the single use macro names
    Context@Disposables \2, init, exit
    
    ; Run the Definition Type init macro
    DefinitionType@TryExec init, \#
endm

/*
    From methods get execute when returning to this Context from another Context with the given name(s)
    - can end with string to make lambda
    - otherwise, need to follow with 'func'
*/
macro Interface@from
    is#String \<_NARG>
    if so
        redef temp@macro equs \<_NARG>
    else
        redef temp@macro equs "\2@from#{d:\2#Froms#_size}"

        Interface@func \1, \2, {temp@macro}

        def \2@from@\<_NARG> equs "{temp@macro}"
    endc

    for i, 3, _narg
        def \2@from@\<i> equs "{temp@macro}"
    endr

endm

macro Interface@lambda
    for i, 2, _narg
        def \1@\<i> equs \<_NARG>
        ; Add the lambda to the list of lambdas
        \1#Lambdas@push \<i>
    endr
endm

macro Interface@lambda#assign
    if def(\2@method)
        if _narg == 3
            def \@#macro equs "Interface@lambda#assign \#,"
            foreach \@#macro, {\3#Lambdas}
        else
            def \@#args equs "\#"
            def \@#continue equs "Interface@lambda#assign#final \3@\4,"
            
            Interface@continue \2@method, \@#continue, \1, \4
        endc
    endc
endm

macro Interface@lambda#assign#final
    redef \2 equs "\1"
endm

/*
    Define a property for this Interface
    \1 - Interface Name
    \2 - Property Initialization Method
    \3 - Property Name
    \4+? - Arguments to forward to Initialization Method
*/
macro Interface@property
    CheckReservedName \3

    ; Add the property ID to the list of properties
    \1#Properties@push \@

    ; Map the property information to a unique identifier
    def \@#macro equs "\2"
    def \@#name equs "\3"
    shift 3
    def \@#args equs "\#"
endm

macro Interface@property#assign
    if def(\2@property)
        if _narg == 3
            def \@#macro equs "Interface@property#assign \#,"
            foreach \@#macro, {\3#Properties}
        else
            def \@#continue equs "Interface@property#assign#final \4,"
            Interface@continue \2@property, \@#continue, \1, {\4#name}
        endc
    endc
endm

macro Interface@property#assign#final
    \1#macro \2, {\1#args}
endm

; define a method for this Interface
macro Interface@method#define
    CheckReservedName \3

    ; Add the method to the list of methods
    \2#Methods@push \3

    Interface@func \1, \2, \2@\3
endm

macro Interface@method#assign
    if def(\2@method)
        if _narg == 3
            def \@#macro equs "Interface@method#assign \#,"
            foreach \@#macro, {\3#Methods}
        else
            def \@#args equs "\#"
            def \@#continue equs "Interface@method#assign#final \@#args,"
            Interface@continue \2@method, \@#continue, \1, \4
        endc
    endc
endm

macro Interface@method#assign#final
    redef \2 equs "Interface@method#execute {\1},"
endm

/*
    To run the definition method
        \1 - Context
        \2 - Type Name
        \3 - Interface Name
        \4 - Method Name
        \5+? - Arguments to forward to Method
*/
macro Interface@method#execute
    def \@#UseSuper_symbol equs "\1#UseSuper"
    def \@#UseSuper_value = \1#UseSuper

    ; enable UseSuper
    def \1#UseSuper = true

    def \@#macro equs "try_exec \3@\4,"

    if def(\2@handle)
        Interface@continue \2@handle, \@#macro, \#
    else
        shift 4
        \@#macro \#
    endc

    ; restore original UseSuper value
    def {\@#UseSuper_symbol} = \@#UseSuper_value
endm

macro Interface@end
    ; Run the Definition Type exit macro
    DefinitionType@TryExec exit, \#

    Context@Close
    pops

    ; define the Interface Name to open a Definition of this Type & Interface
    def \2 equs "\tInterface@open \1, \2, init,"

    ; define the Interface Name 'end' to close the Definition of this Type & Interface
    def \2_End#Definition equs "\tInterface@close \1, \2, exit,"
endm

/*
    \1 - Definition Type
    \2 - Interface Name
    \3 - Interface Method Name (init)
    \4+ - Arguments to pass to Interface Init Macro
*/
macro Interface@open
    ; open the context
    Context@Open \2

    ; Run the Definition Type open macro and/or the Interface init method
    Interface@continue \1@open, Interface@open#init, {Context}, \#
endm

/*  Define the Interface Name methods to hardcode the corresponding context
    This is necessary for UseSupers to make sure it assigned values to proper context
    This also gets called when re-entering, in case a nested context had overwritten this

    \1 - Context
    \2 - Definition Type
    \3 - Interface    */
macro Interface@open#init
    ;define the callback for re-entering this context
    def \1@ReEnter equs "Interface@assign \1, \2, \3"
    
    Interface@assign \1, \2, \3

    ; Initialize the Interface properties
    Interface@property#assign \1, \2, \3

    ; Run the Interface init macro
    Interface@method#execute \#
endm

macro Interface@assign
    ; define the lambdas
    Interface@lambda#assign \1, \2, \3

    ; define the Interface Name methods to include the corresponding context
    Interface@method#assign \1, \2, \3
endm

/*
    \1 - Definition Type
    \2 - Interface Name
    \3 - Interface Method Name (exit)
    \4+ - Arguments to pass to Interface Close Macro
*/
macro Interface@close
    ; Run the Definition Type close macro and/or the Interface exit macro
    Interface@continue \1@close, Interface@method#execute, {Context}, \#

    ; close the context
    Context@Close
endm
