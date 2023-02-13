/*
TODO:
    
    when/unless/then
        -elsewhen, elseunless

    give List a "@Contains" method

    add macro to build a fail message
    CheckReservedName can utilize check_match

    Add comments to all type, scope macros

    Use #, @ where appropriate in context/type/scope members

    Utilize \@ for local macros & returning multiple values
    
    def {self} before running a local method?
    - or, pass it as first argument?

    Handle isPassthrough when parent is the default context
    - i.e. need #LocalMacros list for default...
    -----
    - Can remove the concept of default macros once Text becomes a scope in all scenarios
    - also remove concept of 'kill' macros
    Regex: ^[ \t]+_

    Can remove the concept of PushContext if the Scope Init/Final will push/pop itself

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

macro CheckReservedName
    if strcmp("{\1}","end") == 0
        redef \1 equs "EndDefinition"
    endc
endm

; TODO - need store default macros as #LocalMacros...
macro TryAssignPassthroughMacros
    foreach TryAssignPassthroughMacro, {{{{Context}#Parent}#Name}#LocalMacros}
endm

macro TryAssignPassthroughMacro
    if def({{Context}#Name}_\1) == 0
        {self}#PassthroughMacros@push \1
        def {{Context}#Name}_\1 equs "{{{Context}#Parent}#Name}_\1"
    endc
endm

def Scope equs "\tScopeDefinition"
def self equs "\{Context}"

; To enter the context and initialize if needed
macro enter
    SetContext \1
    
    ; Assign addition properties to the Context
    List {Context}#PassthroughMacros
    redef {Context}#isPassthrough = false

    shift
    try_exec Scope_{{Context}#Name}@Init, \#
    if {{Context}#isPassthrough}
        TryAssignPassthroughMacros
    endc
endm

macro CloseScope
    try_exec Scope_{\1#Name}@Exit
    CloseContext
    try_exec {{Context}#Name}_from_Scope_{\1#Name}
endm

    TryDefineContextMacro ScopeDefinition
macro _ScopeDefinition
    ; Push context so cant write to ROM
    PushContext ScopeDefinition
    
    ; Initialize the list of Local Macros
    List \1#LocalMacros

    redef SCOPE_NAME equs "\1"
    
    ; define the end macro
    def \1_EndDefinition equs "CloseScope \{self}"

    def init equs "single_use init\nmacro Scope_\{SCOPE_NAME}@Init"
    ; todo - can prefix with Scope (or, a unique identifier that all contexts contain)
    ; only when no longer explicitly defining local context macros
    def func equs "macro \{SCOPE_NAME}_\{SCOPE_MACRO_NAME}"
    def final equs "single_use final\nmacro Scope_\{SCOPE_NAME}@Exit"
endm

    TryDefineContextMacro local
macro ScopeDefinition_local
    redef SCOPE_MACRO_NAME equs "\1"
    CheckReservedName SCOPE_MACRO_NAME

    {SCOPE_NAME}#LocalMacros@push {SCOPE_MACRO_NAME}

    TryDefineContextMacro \1
endm

    TryDefineContextMacro from
macro ScopeDefinition_from
    redef SCOPE_MACRO_NAME equs "from_Scope_\1"
endm

    TryDefineContextMacro EndDefinition
macro ScopeDefinition_EndDefinition
    CloseContext
    try_purge func, init, final
endm

    TryDefineContextMacro default
macro ScopeDefinition_default
    DefineDefaultMacros {SCOPE_NAME}, \#
endm

    TryDefineContextMacro kill
macro ScopeDefinition_kill
    DefineExitMacros {SCOPE_NAME}, \#
endm
