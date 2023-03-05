/*
TODO:
    Make ArrayStruct a Struct ?

    Convert all manual Contexts definitions to Struct/Scope

    Can Type and Definition share some common macros?

    Definition Type should be renamed to Context...
    - call context...what? ContextStack?

    Add way to follow 'from' with 'exit' in addition to init
    also, have multiple 'from' names in single line
--------------
    "method" can also define named args
    then, for func, first line after macro definition will assign the names to \@
    - plus, 'rest' for any extra

    add macro to build a fail message
    CheckReservedName can utilize Array@contains

    Add comments to all type, scope macros

    Use #, @ where appropriate in context/type/scope members

    Utilize \@ for local macros & returning multiple values

    Handle isPassthrough when parent is the default context
    - i.e. need #LocalMacros list for default...
    - fix Return context
    -----
    - Can remove the concept of default macros once Text becomes a scope in all scenarios
    - can find with Regex: ^[ \t]+_

    Can remove the concept of Context@Push if the Scope Init/Final will push/pop itself
    - (if it is only used in Scopes...)

    Can extend a scope?
    - can reassign all local, init, and final macros...

    Attach #RegisterSize = 6/18 to all registers
    - i.e. a#RegisterSize
    - use instead of isRegister macro (or, use in the isRegister macro and make that a return value)

    */


/*  A context is a way to have certain macros behave in a particular manner
    When a "context macro" is called, it will execute the macro that belongs to the current context
    If there is no macro in the current context, it will check the parent, and so on
    - Optionally, the context can be restricted to fail if the macro is not defined in the current context, rather than check the parent

    Note: when context is closed, will auto callback if following macro is defined:
    - {NewContext}_{ClosedContext}_Finish

    Context@Push will push the current section, and then change to the next context
    Context@Set will simply change context without pushing the section
    Context@Close will close the current section, and (if pushed) will pop the section
*/

; Initialize the list of context macros
    List Context#Macros

macro Context@init
    def \1#Name equs "\2"
    def \1#isPushed = \3
    def \1#isPassthrough = true
    List \1#Disposables
endm

macro Context@Disposables
    for i, 2, _narg+1
        Context@Disposable \<i>, \1@\<i>
    endr
endm

macro Context@Disposable
    {Context}#Disposables@push \1
    disposable \1, \2
endm

macro Context@Push
    pushs
    Context@push \1, true
endm

macro Context@Set
    Context@push \1, false
endm

macro Context@ExecuteCallback
    {\1#Name}@from@{\2#Name} \1, \2
endm

macro Context@Close
    ; purge the single uses
    try_purge {{Context}#Disposables}

    def \@#doPops = {{Context}#isPushed}

    ; store the closed context name
    def \@#closed_name equs "{{Context}#Name}"

    def \@#closed_context equs "{Context#{d:Context#_size}}"

    Context@pop

    ; if a generic re-enter callback exists, execute it
    if def({Context}@ReEnter)
        {{Context}@ReEnter}
    endc

    ; if the callback exists, execute it
    if def({{Context}#Name}_{\@#closed_name}_Finish)
        {{Context}#Name}_{\@#closed_name}_Finish
    endc

    ; if the callback exists, execute it
    if strlen("{{Context}#Name}") > 0
        if def({{Context}#Name}@from@{\@#closed_name})
            Context@ExecuteCallback {Context}, {\@#closed_context}
        endc
    endc

    ; if the context was pushed, then pop
    if \@#doPops
        pops
    endc
endm

    Stack Context, , 0
    ; disable passthrough for the base context
    def {Context}#isPassthrough = false

/*
TODO:
    instead of checking if the definition exists:
        see if the method exists in Context's list methods?
*/
macro ExecuteContextMacro
    ; Traverse the context stack to find the macro
    for context_i, Context#_size, 0, -1
        if def({{Context#{d:context_i}}#Name}_\1)
            def \@#macro equs "{{Context#{d:context_i}}#Name}_\1"
            shift
            \@#macro \#
            break
        elif !({Context#{d:context_i}}#isPassthrough)
            fail "\1 is not defined in the current context"
        endc
    endr
endm

macro DefineContextMacro
    if _narg > 1
        foreach DefineContextMacro, \#
    elif _narg == 1
        ; if not defined, add it to the list of context macros
        if def(\1) == 0
            Context#Macros@push \1
            def \1 equs "ExecuteContextMacro \1, "
        else
            Context#Macros@contains \1
            if not so
                fail "Cannot set \1 as a Context Macro because is already defined"
            endc
        endc
    endc
endm

    DefineContextMacro End#Definition
    DefineContextMacro Delay
