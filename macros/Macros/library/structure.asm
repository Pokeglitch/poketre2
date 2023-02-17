def Struct equs "\tStructDefinition"

; To enter the context and initialize if needed
macro OpenStruct
    SetContext \1
    
    define_local_macros \1
    
    def {Context}#isPassthrough = false

    shift
    try_exec Struct#{{Context}#Name}@Init, {Context}, \#
endm

macro CloseStruct
    def \@#ClosedStruct equs "{Context}"
    try_exec Struct#{\1#Name}@Exit, {Context}
    CloseContext
    
    define_local_macros {\1#Name}

    try_exec {{Context}#Name}_from_{\1#Name}, {Context}, {\@#ClosedStruct}
endm

    TryDefineContextMacro StructDefinition
macro _StructDefinition
    ; Push context so cant write to ROM
    PushContext StructDefinition
    
    ; Initialize the list of Local Macros
    List \1#LocalMacros

    def {Context}#StructName equs "\1"
    
    ; define the end macro
    def \1_EndDefinition equs "CloseStruct \{Context}"

    redef init equs "single_use init\nmacro Struct#\1@Init"
    redef final equs "single_use final\nmacro Struct#\1@Exit"
endm

    TryDefineContextMacro local
macro StructDefinition_local
    CheckReservedName \1

    {{Context}#StructName}#LocalMacros@push \1

    redef func equs "single_use func\nmacro {{Context}#StructName}@\1"

    TryDefineContextMacro \1
endm

    TryDefineContextMacro from
macro StructDefinition_from
    redef func equs "single_use func\nmacro {{Context}#StructName}_from_\1"
endm

    TryDefineContextMacro EndDefinition
macro StructDefinition_EndDefinition
    def {{Context}#StructName} equs "OpenStruct {{Context}#StructName},"
    CloseContext
    try_purge func, init, final
endm
