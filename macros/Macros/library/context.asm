/*
TODO:
    Can Type and Definition share some common macros?

    Definition Type should be renamed to Context
    - rename Context to Trace
--------------
    - Can remove the concept of default macros once Text becomes a scope in all scenarios
        - can find with Regex: ^[ \t]+_

    Add way to extend a definition
    - can reassign all method, init, exit, etc

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
macro Context@init
    def \1#Name equs "\2"
    def \1#UseSuper = true
    def \1#Disposables equs ""
endm

macro Context@Disposables
    for i, 2, _narg+1
        Context@Disposable \<i>, \1@\<i>
    endr
endm

macro Context@Disposable
    append {Context}#Disposables, \1
    disposable \1, \2
endm

macro Context@Open
    Context@push \1
endm

macro Context@ExecuteCallback
    ; if the callback exists, execute it
    if def({\1#Name}_from@{\2#Name})
        {\1#Name}_from@{\2#Name} \1, \2
    endc
endm

macro Context@Close
    ; purge the single uses
    try_purge {{Context}#Disposables}

    ; store the closed context
    def \@#closed_context equs "{Context#{d:Context#size}}"

    Context@pop

    ; if a generic re-enter callback exists, execute it
    if def({Context}@ReEnter)
        {{Context}@ReEnter}
    endc

    ; try to execute the callback
    Context@ExecuteCallback {Context}, {\@#closed_context}
endm

def Context#size = 0
def Context equs "\{Context#\{d:Context#size}}"

macro Context@push
    ;redef Context equs "\@"
    def Context#size += 1
    redef Context#{d:Context#size} equs "\@"

    def \@#Name equs "\1"
    def \@#UseSuper = true
    def \@#Disposables equs ""
endm

macro Context@pop
    def Context#size -= 1
endm

    Context@push ,

    ; disable UseSuper for the base context
    def {Context}#UseSuper = false

; To call the given macro based on the nearest macro in the context stack
; or until "UseSuper" is false
macro ExecuteContextMacro
    ; Traverse the context stack to find the macro
    for context_i, Context#size, 0, -1
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
        if def(\1) == 0
            def \1 equs "ExecuteContextMacro \1, "
            def Context#Macros#\1 = true
        else
            if def(Context#Macros#\1) == 0
                fail "Cannot set \1 as a Context Macro because is already defined"
            endc
        endc
    endc
endm

    DefineContextMacro End#Definition
    DefineContextMacro Delay
