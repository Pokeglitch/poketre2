; Note: when context is closed, will auto callback if
; {NewContext}_{ClosedContext}_Finish is defined

macro Define_Context
    redef \1Name equs "\2"
    def \1Pushed = \3
    redef \1ParentMacros equs ""
endm

macro PushContext
    pushs
    Push_Context \1, 1
    shift
    DefineParentMacros \#
endm

macro SetContext
    Push_Context \1, 0
    shift
    DefineParentMacros \#
endm

macro DefineParentMacros
    redef {Context}ParentMacros equs "\#"
    foreach _DefineParentMacros, \#
endm

macro _DefineParentMacros
    def {{Context}Name}_\1 equs "{{{Context}_Parent}Name}_\1"
endm

macro PurgeParentMacro
    purge {{Context}Name}_\1
endm

macro CloseContext
    ; if the context was pushed, then pop
    if {Context}Pushed
        pops
    endc

    ; purge any parent macros
    foreach PurgeParentMacro, {{Context}ParentMacros}

    ; Store the potential callback macro name
    redef CONTEXT_CALLBACK equs "{{{Context}_Parent}Name}_{{Context}Name}_Finish"

    Pop_Context

    ; Redefine any parent macros
    DefineParentMacros {{Context}ParentMacros}

    ; if the callback exists, execute it
    if def({CONTEXT_CALLBACK})
        {CONTEXT_CALLBACK}
    endc
endm

; To set the given macro names in this context to call it's default macro
macro DefineDefaultMacros
    redef CONTEXT_NAME equs "\1"
    shift
    foreach _DefineDefaultMacros, \#
endm

macro _DefineDefaultMacros
    def {CONTEXT_NAME}_\1 equs "{DEFAULT_CONTEXT_NAME}_\1"
endm

macro ExecuteContextMacro
    redef EXECUTE_MACRO_NAME equs "\1"
    shift

    if def({{Context}Name}_{EXECUTE_MACRO_NAME})
        {{Context}Name}_{EXECUTE_MACRO_NAME} \#
    else
        fail "{EXECUTE_MACRO_NAME} is not defined in context: {{Context}Name}"
    endc
endm

macro DefineContextMacros
    foreach DefineContextMacro, \#
endm

macro DefineContextMacro
    def \1 equs "ExecuteContextMacro \1, "
endm

    def DEFAULT_CONTEXT_NAME equs "Default"
    Stack Context, {DEFAULT_CONTEXT_NAME}, 0

    DefineContextMacros Team
    DefineContextMacros Warp, Sign, NPC, Battle, Pickup, WarpTo
    DefineContextMacros Delay
    DefineContextMacros Array, Flag, Flags, Index

    DefineContextMacros text, asmtext, asmdone, done, prompt, exit
    DefineContextMacros switch, case, asm
    DefineContextMacros overload, skip
    DefineContextMacros next, end
