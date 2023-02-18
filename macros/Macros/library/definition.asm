/*
    have method be a string macro, not a context macro
    - then, rename routine here back to method

    Dont use List, use same technique that TypeDefinition uses
    add way to add custom methods
    - assign to the instance definition before open/initializing

    TODO - apply handle before init and exit
    - dont forward the Type Name
    - DO forward the Instance Name
    -- shouldnt have to be assigned to #Symbol....
        - also forward to Type Open and Close
*/
def Definition equs "\tDefinitionType@Define"

macro DefinitionInstance@DefineMethods
    if _narg == 3
        foreach 3, DefinitionInstance@DefineMethods, \#, {\3#Routines}
    else
        redef \3_\4 equs "DefinitionInstance@method \4, \3, \2, \1,"
    endc
endm

/*
    \1 - Definition Type Name
*/
macro DefinitionType@Define
    ; Push context so cant write to ROM
    PushContext Definition

    ; Disable passthrough
    def {Context}#isPassthrough = false

    ; Define the single use macro names
    Context@SingleUse Definition#\1, routine, init, exit, open, close, handle

    ; update the DefinitionType End to include the Definition Type Name
    redef Definition_EndDefinition equs "DefinitionType@end \1,"
endm

/*
    \1 - Type Name
*/
macro DefinitionType@end
    ; assign the Type Name to define a Definition Instance of that Type
    def \1 equs "\tDefinitionInstance@Define \1,"
    
    CloseContext
endm

/*
    To try to execute a method assigned to the given Definition Type
    - Enables passthrough before calling
        since this gets called inside the DefinitionInstance context
*/
macro DefinitionType@TryExec
    def {Context}#isPassthrough = true

    def \@#macro equs "Definition#\2@\1"
    shift 2
    try_exec {\@#macro}, \#

    def {Context}#isPassthrough = false
endm


/*  To create a new instance of a definition type
    \1 - Definition Type
    \2 - Definition Instance Name
    \3+ - Arguments to pass to Definition Type Init Macro
*/
macro DefinitionInstance@Define
    PushContext \1

    ; update the method macro to include the name of the instance
    redef \1_method equs "DefinitionInstance@routine \1, \2,"

    ; update the end macro to include the name of the instance
    redef \1_EndDefinition equs "DefinitionInstance@end \1, \2,"

    ; Initialize the list of methods
    ; TODO - use technique that TypeDefinition uses
    List \2#Routines
    
    ; Define the single use macro names
    Context@SingleUse \2, init, exit
    
    ; Run the Definition Type init macro
    DefinitionType@TryExec init, \#
endm

; define a method for this definition instance
macro DefinitionInstance@routine
    CheckReservedName \3

    ; Add the method to the list of methods
    \2#Routines@push \3

    TryDefineContextMacro \3

    ; todo - use Context@SingleUse
    redef func equs "single_use func\nmacro \2@\3"
    
    ; Run the Definition Type method macro
    DefinitionType@TryExec routine, \#
endm

macro DefinitionInstance@end
    ; Run the Definition Type exit macro
    DefinitionType@TryExec exit, \#

    CloseContext

    ; define the Instance Name to open a Definition of this Type & Instance
    def \2 equs "DefinitionInstance@open \1, \2,"

    ; define the Instance Name 'end' to close the Definition of this Type & Instance
    def \2_EndDefinition equs "DefinitionInstance@close \1, \2,"
endm

macro DefinitionInstance@TryExec
    def \@#passthrough = {Context}#isPassthrough

    ; enable passthrough
    def {Context}#isPassthrough = true

    def \@#macro equs "\3@\1"
    shift 3
    try_exec {\@#macro}, {Context}, \#
    
    ; restore original passthrough value
    def {Context}#isPassthrough = \@#passthrough
endm

/*
    \1 - Definition Type
    \2 - Definition Instance Name
    \3+ - Arguments to pass to Definition Instance Init Macro
*/
macro DefinitionInstance@open
    ; open the context
    SetContext \2

    ; TODO - assign custom definition macros
    
    ; define the Instance Name methods to include the corresponding context
    DefinitionInstance@DefineMethods {Context}, \1, \2

    ; Run the Definition Type open macro
    try_exec Definition#\1@open, \2, {Context}
    
    ; Run the Definition Instance init macro
    DefinitionInstance@TryExec init, \#
endm

/*
    To run the definition method
    \1 - Routine Name
    \2 - Instance Name
    \3 - Type Name
    \4 - Context
*/
macro DefinitionInstance@method
    def \@#passthrough = \4#isPassthrough

    ; enable passthrough
    def \4#isPassthrough = true

    if def(Definition#\3@handle)
        ; Run the Definition Type open macro
        try_exec Definition#\3@handle, \#
    else
        def \@#macro equs "\2@\1"
        shift 3
        {\@#macro} \#
    endc
    
    ; restore original passthrough value
    def \1#isPassthrough = \@#passthrough
endm

/*
    \1 - Definition Type
    \2 - Definition Instance Name
    \3+ - Arguments to pass to Definition Instance Close Macro
*/
macro DefinitionInstance@close
    ; Run the Definition Instance exit macro
    DefinitionInstance@TryExec exit, \#
    
    ; Run the Definition Type close macro
    try_exec Definition#\1@close, \2, {Context}

    ; close the context
    CloseContext
endm
