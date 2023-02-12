/*
TODO:
    
    when/unless/then

    give List a "@Contains" method

    macro for "if" to run a macro immediately?
    _if macro_name
    -> how to make sure return value works?
    --> create a return macro...
    1. Store symbol name in RETURN_SYMBOL
    2. return macro will update the value of symbol stored in RETURN_SYMBOL
        3. reset RETURN_SYMBOL to generic: RETURN_VALUE

    then...
    - then equs "if _IF_RETURN_VALUE"
    -also elseif

    add macro to build a fail message
    CheckReservedName can utilize check_match

    Add comments to all type, scope macros

    Use #, @ where appropriate in context/type/scope members
    -----

    - Can remove the concept of default macros once Text becomes a scope in all scenarios
    - also 'kill' macros
    Regex: ^[ \t]+_

    Can remove the concept of PushContext if the Scope Init/Final will push/pop itself

    Can extend a scope?
    - can reassign all local, init, and final macros...

    Use # instead of _ to define scoped macros

    - Scopes always pass through, Types dont?
    -- OR: isPassthrough should be able to be changed during runtime?
    --- always define passthroughs as a macro that will:
    ---- run parent if isPassthrough is 1
    ---- fail if isPassthrough is 0
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
