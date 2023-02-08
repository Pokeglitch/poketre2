Context EQUS "Default"
ContextPushed = 0
ContextCount = 0

MACRO PushContext
    IF _NARG == 1
        SetContext \1
    ELSE
        SetContext \1, \2
    ENDC

    ; set the current context as pushed
    DEF ContextPushed = 1
    PUSHS
ENDM

MACRO SetContext
    ; store the previous context pushed and update
    DEF ContextPushed{d:ContextCount} = ContextPushed
    DEF ContextPushed = 0

    ; store the previous context and update
    REDEF Context{d:ContextCount} EQUS "{Context}"
    REDEF Context EQUS "\1"

    ; increase the context count
    DEF ContextCount += 1
ENDM

; will auto callback if:
; {NewContext}_{ClosedContext}_Finish is defined
MACRO CloseContext
    IF _NARG == 1
        DEF CLOSE_COUNT = \1
    ELSE
        DEF CLOSE_COUNT = 1
    ENDC
    
    REPT CLOSE_COUNT
        IF ContextCount
            DEF ContextCount -= 1

            ; if the context was pushed, then pop
            IF ContextPushed
                POPS
            ENDC

            ; Store the potential callback macro name
            REDEF CALLBACK EQUS "{Context{d:ContextCount}}_{Context}_Finish"

            ; restore the previous context pushed
            DEF ContextPushed = ContextPushed{d:ContextCount}
            REDEF Context EQUS "{Context{d:ContextCount}}"

            ; if the callback exists, execute it
            IF DEF({CALLBACK})
                {CALLBACK}
            ENDC
        ENDC
    ENDR
ENDM

MACRO ExecuteContextMacro
    REDEF EXECUTE_MACRO_NAME EQUS "\1"
    SHIFT

    IF DEF({Context}_{EXECUTE_MACRO_NAME})
        {Context}_{EXECUTE_MACRO_NAME} \#
    ELSE
        fail "{EXECUTE_MACRO_NAME} is not defined in context: {Context}"
    ENDC
ENDM

MACRO DefineContextMacro
    DEF \1 EQUS "ExecuteContextMacro \1, "
ENDM

MACRO DefineDefaultMacros
    DEF CONTEXT_NAME EQUS "\1"
    SHIFT
    REPT _NARG
        DEF {CONTEXT_NAME}_\1 EQUS "Default_\1"
    ENDR
ENDM

MACRO DefineContextMacros
    REPT _NARG
        DefineContextMacro \1
        SHIFT
    ENDR
ENDM
    DefineContextMacros Team
    DefineContextMacros Warp, Sign, NPC, Battle, Pickup, WarpTo
    DefineContextMacros switch, case, end, asm
    DefineContextMacros text, asmtext, asmdone, done, prompt, exit
    DefineContextMacros Delay
    DefineContextMacros Array, Flag, Flags, Index, Skip
