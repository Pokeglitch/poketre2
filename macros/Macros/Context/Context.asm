/*
TODO:
    can define bypass xx to allow UseSuper for explicit functions
    - super should refer to the parent definition
    - bypass should refer to the parent trace
        - so rename usesuper to bypass

    - Finalize CheckReservedName and apply where necessary
        - can utilize Array@contains

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

    lambda: An equs macro
        NOTE - must resolve to a macro
*/
def super equs "fail \"super does not exist for this context\"\n"

incasm Trace


/*
    \1 - Context Name
*/
define Context
func
    ; Push context so cant write to ROM
    pushs
    Trace@Open Context

    ; Disable UseSuper
    def {Trace}#UseSuper = false

    ; Define the single use macro names
    Trace@Disposables \1, init, exit, open, method, property, handle, close

    ; update the Context End to include the Context Name
    redef Context_End#Definition equs "Context@end \1,"
endm

/*
    \1 - Type Name
*/
macro Context@end
    ; assign the Type Name to define a Interface of that Type
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
    Trace@Disposable func, \3
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

/*  To create a new Interface of a Context
    \1 - Context
    \2 - Interface Name
    \3? - Parent Interface to Inherit from
*/
macro Interface@Define
    ; Push context so cant write to ROM
    pushs
    Trace@Open \1

    Interface@SetMacros \1, \2

    ; Initialize the list of members
    def \2#Lambdas equs ""
    def \2#Methods equs ""
    def \2#Properties equs ""
    def \2#AllMacros equs ""
    
    ; Define the single use macro names
    Trace@Disposables \2, init, exit
    
    ; Define the parent if provided
    if _narg == 3
        def \2#Parent equs "\3"
    endc

    ; Run the Context init macro
    Context@TryExec init, \#
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
        redef temp@macro equs "\2@from#\1"

        Interface@func \1, \2, {temp@macro}

        def \2_from@\<_NARG> equs "{temp@macro}"
    endc

    for i, 3, _narg
        def \2_from@\<i> equs "{temp@macro}"
    endr

endm

macro Interface@lambda
    for i, 2, _narg
        def \1@\<i> equs \<_NARG>
        ; Add the lambda to the list of lambdas
        append \1#Lambdas, \<i>
        append \1#AllMacros, \<i>
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
    append \1#Properties, \@

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
    append \2#Methods, \3
    append \2#AllMacros, \3

    Interface@func \1, \2, \2@\3
endm

macro Interface@method#assign
    if def(\2@method)
        if _narg == 3
            def \@#macro equs "Interface@method#assign \#,"
            foreach \@#macro, {\3#Methods}
        else
            def \@#continue equs "Interface@method#assign#final \#,"
            Interface@continue \2@method, \@#continue, \1, \4
        endc
    endc
endm

macro Interface@method#assign#final
    if \3@\4#isSuper
        Super#{\3@\4} \5, \1
    else
        redef \5 equs "Interface@method#execute \1, \2, \3, \4,"
    endc
endm

macro Super#fail
    redef \2 equs "fail \1"
endm

macro Super#Interface@method#execute
    redef \5 equs "Interface@method#execute \6, \2, \3, \4,"
endm

/*
    To run the Context method
        \1 - Context
        \2 - Type Name
        \3 - Interface Name
        \4 - Method Name
        \5+? - Arguments to forward to Method
*/
macro Interface@method#execute
    def \@#prev_super equs "{super}"

    if def(\3#Supers#\4)
        Super#{\3#Supers#\4} super, \1
    else
        ; todo - have supers for init/exit
        redef super equs "fail \"\3 - \4\""
    endc

    def \@#macro equs "try_exec \3@\4,"

    if def(\2@handle)
        Interface@continue \2@handle, \@#macro, \#
    else
        shift 4
        \@#macro \#
    endc
    redef super equs "{\@#prev_super}"
endm

macro Interface@end
    ; Run the Context exit macro
    Context@TryExec exit, \#

    Trace@Close
    pops
    
    ; assign the supers from the parent
    if def(\2#Parent)
        Interface@MapParentMacros {Trace}, \1, \2, {\2#Parent}, {{\2#Parent}#AllMacros}
    endc
  
    ; assign any missing supers to fail
    Interface@InitializeSupers \2, {\2#Methods}, {\2#Lambdas}

    ; define the Interface Name to open a Trace of this Context & Interface
    def \2 equs "\tInterface@open \1, \2, init,"

    ; define the Interface Name 'end' to close the Trace of this Context & Interface
    def \2_End#Definition equs "\tInterface@close \1, \2, exit,"
endm

/*
    \1 - Context
    \2 - Interface Name
    \3 - Interface Method Name (init)
    \4+ - Arguments to pass to Interface Init Macro
*/
macro Interface@open
    ; open the context
    Trace@Open \2

    ; Run the Context open macro and/or the Interface init method
    Interface@continue \1@open, Interface@open#init, {Trace}, \#
endm

/*  Define the Interface Name methods to hardcode the corresponding context
    This is necessary for UseSupers to make sure it assigned values to proper context
    This also gets called when re-entering, in case a nested context had overwritten this

    \1 - Trace
    \2 - Context
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
    \1 - Context
    \2 - Interface Name
    \3 - Interface Method Name (exit)
    \4+ - Arguments to pass to Interface Close Macro
*/
macro Interface@close
    ; Run the Context close macro and/or the Interface exit macro
    Interface@continue \1@close, Interface@method#execute, {Trace}, \#

    ; close the context
    Trace@Close
endm

macro Interface@MapParentMacros
    for i, 5, _narg+1
        def \@#i equs "\<i>"

        ; if not defined in this type, pull from parent
        if not def(\3@{\@#i})
            ; if it is a super in the parent, then interpret it
            if \4@\<i>#isSuper
                redef \3@{\@#i} equs "{\4@\<i>}"
            else
                redef \3@{\@#i} equs "Interface@method#execute {Trace}, \2, \4, {\@#i},"
            endc
            redef \3#Supers#\<i> equs "{\4#Supers#\<i>}"
            redef \3@\<i>#isSuper = 1

            append \3#Methods, {\@#i}
            append \3#AllMacros, {\@#i}
        ; otherwise, the super is the parent
        else
            ; if it is a super in the parent, then interpret it
            if \4@\<i>#isSuper
                redef \3#Supers#\<i> equs "{\4@\<i>}"
            else
                redef \3#Supers#\<i> equs "Interface@method#execute {Trace}, \2, \4, \<i>"
            endc
            redef \3@\<i>#isSuper = 0
        endc
    endr
endm

/*  For all methods that dont have a super, assign the super to fail
    \1 - Type name    */
macro Interface@InitializeSupers
    for i, 2, _narg+1
        if not def(\1#Supers#\<i>)
            def \1#Supers#\<i> equs "fail \"super does not exist for this context\","
            redef \1@\<i>#isSuper = 0
        endc
    endr
endm





incdir Scope, Overload, Return
incdir Struct, ByteStruct
incdir Type, Number, String, List, Stack