; Note: when context is closed, will auto callback if
; {NewContext}_{ClosedContext}_Finish is defined

def end equs "\tEndDefinition"

macro Define_Context
    redef {Context}#Name equs "\2"
    def {Context}#isPushed = \3
endm

    Stack Context, , 0






macro PushContext
    pushs
    Push_Context \1, 1
endm

macro SetContext
    Push_Context \1, 0
endm

macro DefinePassthroughMacros
    redef {Context}#PassthroughMacros equs "\#"
    foreach DefinePassthroughMacro, \#
endm

macro DefinePassthroughMacro
    def {{Context}#Name}_\1 equs "{{{Context}#Parent}#Name}_\1"
endm

macro PurgeParentMacro
    purge {{Context}#Name}_\1
endm

macro CloseContext
    ; if the context was pushed, then pop
    if {Context}#isPushed
        pops
    endc

    ; purge any parent macros
    if def({Context}#PassthroughMacros)
        foreach PurgeParentMacro, {{Context}#PassthroughMacros}
    endc

    ; Store the potential callback macro name
    redef CONTEXT_CALLBACK equs "{{{Context}#Parent}#Name}_{{Context}#Name}_Finish"

    Pop_Context

    ; Redefine any parent macros
    if def({Context}#PassthroughMacros)
        DefinePassthroughMacros {{Context}#PassthroughMacros}
    endc

    ; if the callback exists, execute it
    if def({CONTEXT_CALLBACK})
        {CONTEXT_CALLBACK}
    endc
endm

macro DefineExitMacros
    redef CONTEXT_NAME equs "\1"
    shift
    foreach DefineExitMacro, \#
endm

macro DefineExitMacro
    def {CONTEXT_NAME}_\1 equs "RunDefaultAndExit _\1, "
    TryDefineContextMacro \1
endm

macro RunDefaultAndExit
    redef MACRO_NAME equs "\1"
    shift
    {MACRO_NAME} \#
    end
endm

; To set the given macro names in this context to call it's default macro
macro DefineDefaultMacros
    redef CONTEXT_NAME equs "\1"
    shift
    foreach DefineDefaultMacro, \#
endm

macro DefineDefaultMacro
    def {CONTEXT_NAME}_\1 equs "_\1"
    TryDefineContextMacro \1
endm

macro ExecuteContextMacro
    redef EXECUTE_MACRO_NAME equs "\1"
    shift

    if def({{Context}#Name}_{EXECUTE_MACRO_NAME})
        {{Context}#Name}_{EXECUTE_MACRO_NAME} \#
    elif def(Global_{EXECUTE_MACRO_NAME})
        Global_{EXECUTE_MACRO_NAME} \#
    else
        fail "{EXECUTE_MACRO_NAME} is not defined in context: {{Context}#Name}"
    endc
endm

macro DefineContextMacros
    foreach DefineContextMacro, \#
endm

macro DefineContextMacro
    def \1 equs "ExecuteContextMacro \1, "
endm

macro TryDefineContextMacro
    if def(\1) == 0
        DefineContextMacro \1
    endc
endm

    DefineContextMacros Team
    DefineContextMacros Warp, Sign, NPC, Battle, Pickup, WarpTo
    DefineContextMacros Delay
    DefineContextMacros Array, Flag, Flags, Index

    DefineContextMacros text, asmtext, asmdone, done, prompt, exit_text
    DefineContextMacros switch, case, asm
    DefineContextMacros overload, skip, next
