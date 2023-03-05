/*
TODO:
    Can Type and Definition share some common macros?

    Definition Type should be renamed to Context...
    - call context...what? ContextStack?
--------------
    Handle UseSuper when parent is the default context
    - i.e. need #LocalMacros list for default...
    - fix Return context
    -----
    - Can remove the concept of default macros once Text becomes a scope in all scenarios
    - can find with Regex: ^[ \t]+_

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
        - This is based on the value of the #UseSuper property

    Context@Open will change context
    Context@Close will close the current context
*/

; Initialize the list of context macros
    List Context#Macros

macro Context@init
    def \1#Name equs "\2"
    def \1#UseSuper = true
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

macro Context@Open
    Context@push \1
endm

macro Context@ExecuteCallback
    {\1#Name}@from@{\2#Name} \1, \2
endm

macro Context@Close
    ; purge the single uses
    try_purge {{Context}#Disposables}

    ; store the closed context name
    def \@#closed_name equs "{{Context}#Name}"

    def \@#closed_context equs "{Context#{d:Context#_size}}"

    Context@pop

    ; if a generic re-enter callback exists, execute it
    if def({Context}@ReEnter)
        {{Context}@ReEnter}
    endc

    ; if the callback exists, execute it
    if strlen("{{Context}#Name}") > 0
        if def({{Context}#Name}@from@{\@#closed_name})
            Context@ExecuteCallback {Context}, {\@#closed_context}
        endc
    endc
endm

    Stack Context, , 0
    ; disable UseSuper for the base context
    def {Context}#UseSuper = false

; To call the given macro based on the nearest macro in the context stack
; or until "UseSuper" is false
macro ExecuteContextMacro
    ; Traverse the context stack to find the macro
    for context_i, Context#_size, 0, -1
        if def({{Context#{d:context_i}}#Name}_\1)
            def \@#macro equs "{{Context#{d:context_i}}#Name}_\1"
            shift
            \@#macro \#
            break
        elif !({Context#{d:context_i}}#UseSuper)
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
