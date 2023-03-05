/*
TODO:
    - Can remove the concept of default macros once Text becomes a scope in all scenarios
        - can find with Regex: ^[ \t]+_
--------------
    Move the parent/super to Context itself, instead of only in Type?

    Add way to extend any context
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

    Trace@Open will change context
    Trace@Close will close the current context
*/
macro Trace@init
    def \1#Name equs "\2"
    def \1#UseSuper = true
    def \1#Disposables equs ""
endm

macro Trace@Disposables
    for i, 2, _narg+1
        Trace@Disposable \<i>, \1@\<i>
    endr
endm

macro Trace@Disposable
    append {Trace}#Disposables, \1
    disposable \1, \2
endm

macro Trace@Open
    Trace@push \1
endm

macro Trace@ExecuteCallback
    ; if the callback exists, execute it
    if def({\1#Name}_from@{\2#Name})
        {\1#Name}_from@{\2#Name} \1, \2
    endc
endm

macro Trace@Close
    ; purge the single uses
    try_purge {{Trace}#Disposables}

    ; store the closed context
    def \@#closed_context equs "{Trace#{d:Trace#size}}"

    Trace@pop

    ; if a generic re-enter callback exists, execute it
    if def({Trace}@ReEnter)
        {{Trace}@ReEnter}
    endc

    ; try to execute the callback
    Trace@ExecuteCallback {Trace}, {\@#closed_context}
endm

def Trace#size = 0
def Trace equs "\{Trace#\{d:Trace#size}}"

macro Trace@push
    ;redef Context equs "\@"
    def Trace#size += 1
    redef Trace#{d:Trace#size} equs "\@"

    def \@#Name equs "\1"
    def \@#UseSuper = true
    def \@#Disposables equs ""
endm

macro Trace@pop
    def Trace#size -= 1
endm

    Trace@push ,

    ; disable UseSuper for the base context
    def {Trace}#UseSuper = false

; To call the given macro based on the nearest macro in the context stack
; or until "UseSuper" is false
macro ExecuteContextMacro
    ; Traverse the context stack to find the macro
    for context_i, Trace#size, 0, -1
        if def({{Trace#{d:context_i}}#Name}_\1)
            def \@#macro equs "{{Trace#{d:context_i}}#Name}_\1"
            shift
            \@#macro \#
            break
        elif !({Trace#{d:context_i}}#UseSuper)
            fail "\1 is not defined in the {{Trace#{d:context_i}}#Name} Context"
        endc
    endr
endm

macro DefineContextMacro
    if _narg > 1
        foreach DefineContextMacro, \#
    elif _narg == 1
        if def(\1) == 0
            def \1 equs "ExecuteContextMacro \1, "
            def Trace#Macros#\1 = true
        else
            if def(Trace#Macros#\1) == 0
                fail "Cannot set \1 as a Context Macro because is already defined"
            endc
        endc
    endc
endm

    DefineContextMacro End#Definition
