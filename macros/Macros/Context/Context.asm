/*
TODO:
    Get "super" working for From
        - Dont add From to froms list if already defined
    From should trigger when returning from a Context that inherits from the context defined in the 'from' statement

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

    lambda: An equs macro
        NOTE - must resolve to a macro

    forward: Macro to permit access through isolation
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

    ; Enable Isolate
    def {Trace}#Isolate = true

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
    dispose from, method, lambda, property, forward, \1_End#Definition
endm

; set the macros to include the name of the Interface
macro Interface@SetMacros
    redef from equs "Interface@from \1, \2,"
    redef forward equs "Interface@forward \2,"
    redef method equs "Interface@method#define \1, \2,"
    redef lambda equs "Interface@lambda \2,"
    redef property equs "Interface@property \2,"
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
    def \2#Forwards equs ""
    def \2#Froms equs ""
    
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
        redef temp@name equs "\2@from@\<_NARG>#Definition"

        Interface@func \1, \2, {temp@name}

        redef temp@macro equs "Interface@from#execute \2@from@\<_NARG>,"
        Interface@from#define \2, from@\<_NARG>, temp@macro
    endc

    for i, 3, _narg
        Interface@from#define \2, from@\<i>, temp@macro
    endr
endm

macro Interface@from#define
    def \1@\2 equs "{\3}"
    append \1#Froms, \2
endm

macro Interface@from#inherit
    for i, 3, _narg+1
        Interface@from#define \1, \<i>, \2@\<i>
    endr
endm

macro Interface@forward
    for i, 2, _narg+1
        ; Add the method to the list of forwards
        Interface@forward#define \1, \<i>
    endr
endm

macro Interface@forward#inherit
    for i, 2, _narg+1
        ; Add the method to the list of forwards if not already there
        if not def(\1#Forwards#\<i>)
            Interface@forward#define \1, \<i>
        endc
    endr
endm

macro Interface@forward#define
    ; Add the method to the list of forwards
    def \1#Forwards#\2 = true
    append \1#Forwards, \2
endm

macro Interface@forward#assign
    for i, 2, _narg+1
        def \1#Forwards#\<i> = true
    endr
endm

macro Interface@lambda
    for i, 2, _narg
        def \1@\<i> equs \<_NARG>
        def \1@\<i>#isLambda = true
        ; Add the lambda to the list of lambdas
        append \1#Lambdas, \<i>
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

    def \@#obj equs "\1#Properties#\3"

    ; Add the property ID to the list of properties
    append \1#Properties, \3

    ; Map the property information to a unique identifier
    def \1#Properties#\3#macro equs "\2"
    def \1#Properties#\3#name equs "\3"
    shift 3
    def {\@#obj}#args equs "\#"
endm

macro Interface@property#inherit
    for i, 3, _narg+1
        if not def(\1#Properties#\<i>)
            def \1#Properties#\<i>#macro equs "{\2#Properties#\<i>#macro}"
            def \1#Properties#\<i>#name equs "{\2#Properties#\<i>#name}"
            def \1#Properties#\<i>#args equs "{\2#Properties#\<i>#args}"
            append \1#Properties, \<i>
        endc
    endr
endm

macro Interface@property#assign
    if def(\2@property)
        if _narg == 3
            def \@#macro equs "Interface@property#assign \#,"
            foreach \@#macro, {\3#Properties}
        else
            def \@#continue equs "Interface@property#assign#final \3#Properties#\4,"
            Interface@continue \2@property, \@#continue, \1, {\3#Properties#\4#name}
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

    def \2@\3#isLambda = false

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
        {\3@\4} \5, \1
    else
        redef \5 equs "Interface@method#execute \1, \2, \3, \4,"
    endc
endm

macro Interface@super#fail
    redef \1 equs "fail \"super does not exist for this context\","
endm

macro Interface@super#assign
    if def(\2@\3#isLambda)
        if \2@\3#isLambda
            redef \4 equs "\2@\3"
        else
            redef \4 equs "Interface@method#execute \5, \1, \2, \3,"
        endc
    ; if isLambda is not defined, then its init or exit
    else
        if def(\2@\3)
            redef \4 equs "Interface@method#execute \5, \1, \2, \3,"
        else
            Interface@super#fail \4
        endc
    endc
endm
macro Special#Interface@super#assign
    def \@#macro equs "Interface@method#execute \4, \1, \2, \3,"
    shift 4
    \@#macro \#
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

    {\3@\4#Super} super, \1

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
    
    ; inherit from parent/assign supers
    if def(\2#Parent)
        if def(\2@init)
            append \2#Methods, init
        endc
        if def(\2@exit)
            append \2#Methods, exit
        endc

        
        Interface@property#inherit \2, {\2#Parent}, {{\2#Parent}#Properties}
        Interface@super#inherit \1, \2, {\2#Parent}, {{\2#Parent}#Methods}
        Interface@super#inherit \1, \2, {\2#Parent}, {{\2#Parent}#Lambdas}
        Interface@super#inherit2 \1, \2, {\2#Parent}, {{\2#Parent}#Froms}
        Interface@forward#inherit \2, {{\2#Parent}#Forwards}
        ;Interface@from#inherit \2, {\2#Parent}, {{\2#Parent}#Froms}
    else
        append \2#Methods, init, exit
    endc
    
    ; assign any missing supers to fail
    Interface@super#define#fail \2, {\2#Methods}
    Interface@super#define#fail \2, {\2#Lambdas}
    Interface@super#define#fail2 \2, {\2#Froms}

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
    This is necessary for Isolates to make sure it assigned values to proper context
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

    ; Initialize the Forwards
    Interface@forward#assign \1, {\3#Forwards}

    ; execute the super init macro
    if \3@\4#isSuper
        def \@#macro equs "Special#{\3@\4} \1,"
        shift 4
        \@#macro \#
    else
        ; Run the Interface init macro
        Interface@method#execute \#
    endc
endm

macro Interface@assign
    ; define the lambdas
    Interface@lambda#assign \1, \2, \3

    ; define the Interface Name methods to include the corresponding Trace
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
    Interface@continue \1@close, Interface@close#exit, {Trace}, \#

    ; close the context
    Trace@Close
endm

/*  \1 - Trace
    \2 - Context
    \3 - Interface    */
macro Interface@close#exit
    ; execute the super exit macro
    if \3@\4#isSuper
        def \@#macro equs "Special#{\3@\4} \1,"
        shift 4
        \@#macro \#
    else
        Interface@method#execute \#
    endc
endm

macro Interface@super#inherit
    for i, 4, _narg+1
        ; if not defined in this type, pull from parent
        if not def(\2@\<i>)
            Interface@super#define \2@\<i>, \1, \3, \<i>

            redef \2@\<i>#Super equs "\3@\<i>#Super"
            redef \2@\<i>#isSuper = true
            
            append \2#Methods, \<i>
        ; otherwise, the super is the parent
        else
            Interface@super#define \2@\<i>#Super, \1, \3, \<i>
            redef \2@\<i>#isSuper = false
        endc
    endr
endm

macro Interface@super#inherit2
    for i, 4, _narg+1
        ; if not defined in this type, pull from parent
        if not def(\2@\<i>)
            Interface@super#define2 \2@\<i>, \1, \3, \<i>

            redef \2@\<i>#Super equs "{\3@\<i>#Super}"
            redef \2@\<i>#isSuper = true
            
            append \2#Froms, \<i>
        ; otherwise, the super is the parent
        else
            Interface@super#define2 \2@\<i>#Super, \1, \3, \<i>
            redef \2@\<i>#isSuper = false
        endc
    endr
endm
/*
    \1 - Symbol to assign to
    \2 - Context
    \3 - Parent Interface
    \4 - Method
*/
macro Interface@super#define2
    redef \1 equs "{\3@\4}"
endm

macro Interface@from#execute
    def \@#prev_super equs "{super}"
    redef super equs "Interface@from#super \1#Super, \2, \3,"
    exec \1#Definition, \2, \3
    redef super equs "{\@#prev_super}"
endm

macro Interface@from#super
    {\1} \2, \3
endm

/*
    \1 - Symbol to assign to
    \2 - Context
    \3 - Parent Interface
    \4 - Method
*/
macro Interface@super#define
    ; if it is a super in the parent, then copy it
    if \3@\4#isSuper
        redef \1 equs "{\3@\4}"
    ; otherwise, assign it to be that parent method
    else
        redef \1 equs "Interface@super#assign \2, \3, \4,"
    endc
endm

/*  For all methods that dont have a super, assign the super to fail
    \1 - Type name    */
macro Interface@super#define#fail
    for i, 2, _narg+1
        if not def(\1@\<i>#Super)
            redef \1@\<i>#Super equs "Interface@super#fail"
            redef \1@\<i>#isSuper = false
        endc
    endr
endm

/*  For all methods that dont have a super, assign the super to fail
    \1 - Type name    */
macro Interface@super#define#fail2
    for i, 2, _narg+1
        if not def(\1@\<i>#Super)
            Interface@super#fail \1@\<i>#Super
            redef \1@\<i>#isSuper = false
        endc
    endr
endm




incdir Scope, Overload, Return
incdir Struct, ByteStruct
incdir Type, Number, String, List, Stack
