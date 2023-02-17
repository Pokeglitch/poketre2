/*
TODO:
    Convert all manual Contexts definitions to Structure

    - update 'self' same way we update 'super'
    -- also have self and super work for Scope methods?
--------------
    Remove "Global_" names

    Give String Type functions like equals, contains, startswith, etc

    add macro to build a fail message
    CheckReservedName can utilize List@contains

    Add comments to all type, scope macros

    Use #, @ where appropriate in context/type/scope members

    Utilize \@ for local macros & returning multiple values
    
    def {self} before running a local method?
    - or, pass it as first argument?

    Handle isPassthrough when parent is the default context
    - i.e. need #LocalMacros list for default...
    - fix Return context
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

def Scope equs "\tScopeDefinition"
def self equs "\{Context}"

macro define_local_macros
    ; Assign the local macros
    foreach 1, define_local_macro, \1, {\1#LocalMacros}
endm

macro define_local_macro
    redef \1_\2 equs "\1@\2 {{Context}#ID},"
endm

; To enter the context and initialize if needed
macro enter
    SetContext \1
    
    define_local_macros \1

    shift
    try_exec Scope_{{Context}#Name}@Init, {Context}, \#
endm

macro CloseScope
    def \@#ClosedScope equs "{Context}"
    try_exec Scope_{\1#Name}@Exit, {Context}
    CloseContext
    
    define_local_macros {\1#Name}

    try_exec {{Context}#Name}_from_{\1#Name}, {Context}, {\@#ClosedScope}
endm

    ; TODO - SCOPE_NAME can be a symbol attached to the current ScopeDefinition scope
    TryDefineContextMacro ScopeDefinition
macro _ScopeDefinition
    ; Push context so cant write to ROM
    PushContext ScopeDefinition
    
    ; Initialize the list of Local Macros
    List \1#LocalMacros

    redef SCOPE_NAME equs "\1"
    
    ; define the end macro
    def \1_EndDefinition equs "CloseScope \{self}"

    redef init equs "single_use init\nmacro Scope_\{SCOPE_NAME}@Init"
    redef final equs "single_use final\nmacro Scope_\{SCOPE_NAME}@Exit"
endm

    TryDefineContextMacro local
macro ScopeDefinition_local
    redef SCOPE_MACRO_NAME equs "\1"
    CheckReservedName SCOPE_MACRO_NAME

    {SCOPE_NAME}#LocalMacros@push {SCOPE_MACRO_NAME}

    redef func equs "single_use func\nmacro \{SCOPE_NAME}@\{SCOPE_MACRO_NAME}"

    TryDefineContextMacro \1
endm

    TryDefineContextMacro from
macro ScopeDefinition_from
    redef SCOPE_MACRO_NAME equs "from_\1"
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
