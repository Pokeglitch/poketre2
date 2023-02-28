/*
TODO:
    - Use self/Super scope in Type handle method
    -- also have self and super work for Scope methods?

    Make ArrayStruct a Struct\

    Convert all manual Contexts definitions to Struct/Scope
--------------
    "method" can also define named args
    then, for func, first line after macro definition will assign the names to \@
    - plus, 'rest' for any extra

    Rename "is" to "does" (for contains, etc)

    - can all protos be base types?

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
    - also remove concept of 'kill' macros
    Regex: ^[ \t]+_

    Can remove the concept of Context@Push if the Scope Init/Final will push/pop itself
    - (if it is only used in Scopes...)

    Can extend a scope?
    - can reassign all local, init, and final macros...

    - Scopes always pass through, Types dont?
    -- OR: isPassthrough should be able to be changed during runtime?
    --- always define passthroughs as a macro that will:
    ---- run parent if isPassthrough is 1
    ---- fail if isPassthrough is 0

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
    if _narg > 2
        foreach 1, Context@Disposables, \#
    else
        Context@Disposable \2, \1@\2
    endc
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

macro Context@Close
    ; purge the single uses
    try_purge {{Context}#Disposables}

    ; if the context was pushed, then pop
    if {Context}#isPushed
        pops
    endc

    ; store the closed context name
    def \@#closed_name equs "{{Context}#Name}"

    Context@pop

    ; if the callback exists, execute it
    if def({{Context}#Name}_{\@#closed_name}_Finish)
        {{Context}#Name}_{\@#closed_name}_Finish
    endc

    ; if a generic re-enter callback exists, execute it
    if def({Context}@ReEnter)
        {{Context}@ReEnter}
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
    else
        ; if not defined, add it to the list of context macros
        if def(\1) == 0
            Context#Macros@push \1
            def \1 equs "ExecuteContextMacro \1, "
        else
            Context#Macros@contains \1
            if not
                fail "Cannot set \1 as a Context Macro because is already defined"
            endc
        endc
    endc
endm

    DefineContextMacro End#Definition
    DefineContextMacro Team
    DefineContextMacro Warp, Sign, NPC, Battle, Pickup, WarpTo
    DefineContextMacro Delay

    DefineContextMacro text, asmtext, asmdone, done, prompt, exit_text
    DefineContextMacro switch, case, asm
