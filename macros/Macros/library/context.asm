macro Define_Context
    redef \1Name equs "\2"
    def \1Pushed = \3
endm

macro PushContext
    Push_Context \1, 1
    pushs
endm

macro SetContext
    Push_Context \1, 0
endm

; will auto callback if:
; {NewContext}_{ClosedContext}_Finish is defined
macro CloseContext
    if _NARG == 1
        def CLOSE_COUNT = \1
    else
        def CLOSE_COUNT = 1
    endc

    rept CLOSE_COUNT
        ; if the context was pushed, then pop
        if {Context}Pushed
            pops
        endc

        ; Store the potential callback macro name
        redef CALLBACK equs "{{{Context}_Parent}Name}_{{Context}Name}_Finish"

        Pop_Context

        ; if the callback exists, execute it
        if def({CALLBACK})
            {CALLBACK}
        endc
    endr
endm

macro DefineDefaultMacros
    def CONTEXT_NAME equs "\1"
    shift

    rept _NARG
        def {CONTEXT_NAME}_\1 equs "{DEFAULT_CONTEXT_NAME}_\1"
        shift
    endr
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

macro DefineContextMacro
    def \1 equs "ExecuteContextMacro \1, "
endm

macro DefineContextMacros
    rept _NARG
        DefineContextMacro \1
        shift
    endr
endm

    def DEFAULT_CONTEXT_NAME equs "Default"
    Stack Context, {DEFAULT_CONTEXT_NAME}, 0

    DefineContextMacros Team
    DefineContextMacros Warp, Sign, NPC, Battle, Pickup, WarpTo
    DefineContextMacros switch, case, end, asm
    DefineContextMacros text, asmtext, asmdone, done, prompt, exit
    DefineContextMacros Delay
    DefineContextMacros Array, Flag, Flags, Index, Skip
