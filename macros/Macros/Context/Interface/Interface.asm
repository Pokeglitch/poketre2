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
        Interface@from#inherit \1, \2, {\2#Parent}, {{\2#Parent}#Froms}
        Interface@forward#inherit \2, {{\2#Parent}#Forwards}
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

macro Interface@super#fail
    redef \1 equs "fail \"super does not exist for this context\","
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
