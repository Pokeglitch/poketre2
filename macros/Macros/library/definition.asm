/*  A Definition creates a new Context Type
    Then, this Context Type can be used to create new Context Instances
    Finally, a Context Instance can entered/exited throughout the source

    The following macros can be are utilized by a Definition:
        - (any can also be skipped)

    init: run when a new Instance of this Type is initialized
        \1   - Instance Name
        \2+? - Additional arguments 

    exit: run when a new Instance of this Type is exited
        \1 - Instance Name
        \2+? - Additional arguments

    open: run when an Instance is opened
        \1 - Context
        \2 - Type Name
        \3 - Instance Name
        \4 - Method Name (init)
        \5+? - Additional arguments

        To execute the Instance "init" method:
        - continue \#

    close: run when an Instance is closed
        \1 - Context
        \2 - Type Name
        \3 - Instance Name
        \4 - Method Name (init)
        \5+? - Additional arguments

        To execute the Instance "exit" method:
        - continue \#
*/


/*
    TODO-
    -can assign names to arguments using the 'method' function definition macro?
        -can use same "context" that super uses and make them context arguments
*/
def Definition equs "\tDefinitionType@Define"

/*
    \1 - Definition Type Name
*/
macro DefinitionType@Define
    ; Push context so cant write to ROM
    Context@Push Definition

    ; Disable passthrough
    def {Context}#isPassthrough = false

    ; Define the single use macro names
    Context@SingleUses \1, init, exit, open, method, property, handle, close

    ; update the DefinitionType End to include the Definition Type Name
    redef Definition_EndDefinition equs "DefinitionType@end \1,"
endm

/*
    \1 - Type Name
*/
macro DefinitionType@end
    ; assign the Type Name to define a Definition Instance of that Type
    def \1 equs "\tDefinitionInstance@Define \1,"

    Context@Close
endm

/*
    To try to execute a method assigned to the given Definition Type
    - Enables passthrough before calling
        since this gets called inside the DefinitionInstance context
*/
macro DefinitionType@TryExec
    def {Context}#isPassthrough = true

    def \@#macro equs "\2@\1"
    shift 2
    try_exec {\@#macro}, \#

    def {Context}#isPassthrough = false
endm

macro DefinitionInstance@continue
    if def(\1)
        redef continue equs "single_use continue\n\t\2"
        def \@#macro equs "\1"
    else
        def \@#macro equs "\2"
    endc

    shift 2
    \@#macro \#
    try_purge continue
endm


/*  To create a new instance of a definition type
    \1 - Definition Type
    \2 - Definition Instance Name
    \3+ - Arguments to pass to Definition Type Init Macro
*/
macro DefinitionInstance@Define
    Context@Push \1

    ; update the method macro to include the name of the instance
    redef method equs "DefinitionInstance@method#define \1, \2,"

    ; update the property macro to include the name of the instance
    redef property equs "DefinitionInstance@property \1, \2,"

    ; update the end macro to include the name of the instance
    redef \1_EndDefinition equs "DefinitionInstance@end \1, \2,"

    ; Initialize the list of members
    List \2#Methods
    List \2#Properties
    
    ; Define the single use macro names
    Context@SingleUses \2, init, exit
    
    ; Run the Definition Type init macro
    DefinitionType@TryExec init, \#
endm

/*
    Define a property for this definition instance
    \1 - Type Name
    \2 - Instance Name
    \3 - Property Initialization Method
    \4 - Property Name
    \5+? - Arguments to forward to Initialization Method
*/
macro DefinitionInstance@property
    CheckReservedName \4

    ; Add the property ID to the list of properties
    \2#Properties@push \@

    ; Map the property information to a unique identifier
    def \@#macro equs "\3"
    def \@#name equs "\4"
    shift 4
    def \@#args equs "\#"
endm

macro DefinitionInstance@property#assign
    if def(\2@property)
        if _narg == 3
            foreach 3, DefinitionInstance@property#assign, \#, {\3#Properties}
        else
            def \@#continue equs "DefinitionInstance@property#assign#final \4,"
            DefinitionInstance@continue \2@property, \@#continue, \1, {\4#name}
        endc
    endc
endm

macro DefinitionInstance@property#assign#final
    \1#macro \2, {\1#args}
endm

; define a method for this definition instance
macro DefinitionInstance@method#define
    CheckReservedName \3

    ; Add the method to the list of methods
    \2#Methods@push \3

    Context@SingleUse func, \2@\3
endm

macro DefinitionInstance@method#assign
    if def(\2@method)
        if _narg == 3
            foreach 3, DefinitionInstance@method#assign, \#, {\3#Methods}
        else
            def \@#args equs "\#"
            def \@#continue equs "DefinitionInstance@method#assign#final \@#args,"
            DefinitionInstance@continue \2@method, \@#continue, \1, \4
        endc
    endc
endm

macro DefinitionInstance@method#assign#final
    redef \2 equs "DefinitionInstance@method#execute {\1},"
endm

/*
    To run the definition method
        \1 - Context
        \2 - Type Name
        \3 - Instance Name
        \4 - Method Name
        \5+? - Arguments to forward to Method
*/
macro DefinitionInstance@method#execute
    def \@#passthrough_symbol equs "\1#isPassthrough"
    def \@#passthrough_value = \1#isPassthrough

    ; enable passthrough
    def \1#isPassthrough = true

    def \@#macro equs "try_exec \3@\4,"

    if def(\2@handle)
        DefinitionInstance@continue \2@handle, \@#macro, \#
    else
        shift 4
        \@#macro \#
    endc

    ; restore original passthrough value
    def {\@#passthrough_symbol} = \@#passthrough_value
endm

macro DefinitionInstance@end
    ; Run the Definition Type exit macro
    DefinitionType@TryExec exit, \#

    Context@Close

    ; define the Instance Name to open a Definition of this Type & Instance
    def \2 equs "DefinitionInstance@open \1, \2, init,"

    ; define the Instance Name 'end' to close the Definition of this Type & Instance
    def \2_EndDefinition equs "DefinitionInstance@close \1, \2, exit,"
endm

/*
    \1 - Definition Type
    \2 - Definition Instance Name
    \3 - Instance Method Name (init)
    \4+ - Arguments to pass to Definition Instance Init Macro
*/
macro DefinitionInstance@open
    ; open the context
    Context@Set \2

    ; Run the Definition Type open macro and/or the Instance init method
    DefinitionInstance@continue \1@open, DefinitionInstance@open#init, {Context}, \#
endm

/*  Define the Instance Name methods to hardcode the corresponding context
    This is necessary for passthroughs to make sure it assigned values to proper context
    This also gets called when re-entering, in case a nested context had overwritten this

    \1 - Context
    \2 - Definition Type
    \3 - Definition Instance    */
macro DefinitionInstance@open#init
    ;define the callback for re-entering this context
    def \1@ReEnter equs "DefinitionInstance@method#assign \1, \2, \3"

    ; define the Instance Name methods to include the corresponding context
    DefinitionInstance@method#assign \1, \2, \3

    ; Initialize the Instance properties
    DefinitionInstance@property#assign \1, \2, \3

    ; Run the Definition Instance init macro
    DefinitionInstance@method#execute \#
endm

/*
    \1 - Definition Type
    \2 - Definition Instance Name
    \3 - Instance Method Name (exit)
    \4+ - Arguments to pass to Definition Instance Close Macro
*/
macro DefinitionInstance@close
    ; Run the Definition Type close macro and/or the Instance exit macro
    DefinitionInstance@continue \1@close, DefinitionInstance@method#execute, {Context}, \#

    ; close the context
    Context@Close
endm
