def end equs "\tEndDefinition"

; todo - this will refer to a new context if one is enter, and then that same macro calls '{self}'
def self equs "\{Context}"
    

; To enter the context and initialize if needed
macro enter
    SetContext \1
    shift
    try_exec Scope_{{Context}#Name}_Init, \#
endm

macro exit
    CloseScope {Context}
endm

macro CloseScope
    try_exec Scope_{\1#Name}_Exit
    CloseContext
    try_exec {{Context}#Name}_from_Scope_{\1#Name}
endm

/*
Auto passthrough?

Scope macro types:
- init
- func
- final

Also:
    default <name> will set those as defaults
    exit - will run default and then exit after
    from <name> will run when returning to this context from <name> context

Save a child so it can be re-acccessed later?
- but also can be overwritten...

the first argument needs to be self, so it can still be referred to even after creating a new instance...
    - actually, only for classes...
*/

def Scope equs "\tScopeDefinition"

    DefineContextMacro ScopeDefinition
macro Default_ScopeDefinition
    redef SCOPE_NAME equs "\1"
    SetContext ScopeDefinition

    def init equs "single_use init\nmacro Scope_\{SCOPE_NAME}_Init"
    ; todo - can prefix with Scope (or, a unique identifier that all contexts contain)
    ; only when no longer explicitly defining local context macros
    def func equs "macro \{SCOPE_NAME}_\{SCOPE_MACRO_NAME}"
    def final equs "single_use final\nmacro Scope_\{SCOPE_NAME}_Exit"
endm


    DefineContextMacro local
macro ScopeDefinition_local
    redef SCOPE_MACRO_NAME equs "\1"

    TryDefineContextMacro \1
endm

    DefineContextMacro from
macro ScopeDefinition_from
    redef SCOPE_MACRO_NAME equs "from_Scope_\1"
endm

    DefineContextMacro EndDefinition
macro ScopeDefinition_EndDefinition
    CloseContext
    try_purge func, init, final
endm
