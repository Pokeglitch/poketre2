def super equs "fail \"super does not exist for this context\"\n"
def _nname equs "fail \"_nname does not exist for this context\"\n"

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

macro Interface@args
    Trace@Disposable args, \3
    redef args equs "\tInterface@SetMacros \1, \2\n{args}\n\tdefine_args"
    dispose from, method, property, forward, \1_End#Definition
endm

; set the macros to include the name of the Interface
macro Interface@SetMacros
    redef from equs "Interface@from \1, \2,"
    redef forward equs "Interface@forward \2,"
    redef method equs "Interface@method \1, \2,"
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
    def \2#Properties equs ""
    def \2#Forwards equs ""
    def \2#Functions equs ""
    
    ; Define the parent if provided
    if _narg == 3
        def \2#Parent equs "\3"
    endc

    ; Run the Context new macro
    Context@TryExec new, \#
endm

macro Interface@end
    ; Run the Context finish macro
    Context@TryExec finish, \#

    Trace@Close
    pops
    
    ; inherit from parent/assign supers
    if def(\2#Parent)
        Interface@property#inherit \2, {\2#Parent}, {{\2#Parent}#Properties}
        Interface@method#inherit \1, \2, {\2#Parent}, {{\2#Parent}#Functions}
        Interface@forward#inherit \2, {{\2#Parent}#Forwards}
    endc
    
    ; assign any missing supers to fail
    Interface@method#inherit#fail \2, {\2#Functions}

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

    def {Trace}#Context equs "\1"

    ; Run the Context open macro and/or the Interface init method
    Interface@continue \1@open, Interface@open#init, {Trace}, \#
endm

/*  Define the Interface Name methods to hardcode the corresponding context
    This is necessary for Isolates to make sure it assigned values to proper context

    \1 - Trace
    \2 - Context
    \3 - Interface    */
macro Interface@open#init
    ;define the callback for re-entering this context (to re-assign methods in-case a child context overwrote it)
    def \1@ReEnter equs "Interface@method#assign \1, \2, \3, \{\3#Functions}"
    
    ; define the Interface Name methods to include the corresponding Trace
    Interface@method#assign \1, \2, \3, {\3#Functions}

    ; Initialize the Interface properties
    Interface@property#assign \1, \2, \3

    ; Initialize the Forwards
    Interface@forward#assign \1, {\3#Forwards}

    ; execute the init macro
    try_exec \3@init, \#
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
    ; execute the exit macro
    try_exec \3@exit, \#
endm
