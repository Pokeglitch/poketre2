Context EQUS "Default"
ContextPushed = 0
ContextCount = 0

PushContext: MACRO
    IF _NARG == 1
        SetContext \1
    ELSE
        SetContext \1, \2
    ENDC

    ; set the current context as pushed
    DEF ContextPushed = 1
    PUSHS
ENDM

SetContext: MACRO
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
CloseContext: MACRO
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

            ; if a callback is defined, then run it\
            REDEF CALLBACK EQUS "{Context{d:ContextCount}}_{Context}_Finish"
            IF DEF({CALLBACK})
                {CALLBACK}
            ENDC

            ; restore the previous context pushed
            DEF ContextPushed = ContextPushed{d:ContextCount}
            REDEF Context EQUS "{Context{d:ContextCount}}"
        ENDC
    ENDR
ENDM

DEF AccumulateArgs EQUS "\n\
REDEF ARGS_STR EQUS \"\"\n\
REPT _NARG\n\
    IF STRCMP(\"\{ARGS_STR\}\", \"\") != 0\n\
        REDEF ARGS_STR EQUS STRCAT(\"\{ARGS_STR\}\",\", \")\n\
    ENDC\n\
    REDEF ARGS_STR EQUS STRCAT(\"\{ARGS_STR\}\",\"\\1\")\n\
    SHIFT\n\
ENDR"

DefineContextMacro: MACRO
REDEF CONTEXT_MACRO_STR EQUS "\1: MACRO\n\
IF DEF(\{Context\}_\1)\n\
    AccumulateArgs\n\
    \{Context\}_\1 \{ARGS_STR\}\n\
ELSE\n\
    fail \"\1 is not defined in context: \{Context\}\"\n\
ENDC\nENDM"
{CONTEXT_MACRO_STR}
ENDM

ForwardToMacro: MACRO
    \1 {ARGS_STR}
ENDM

REDEF ForwardTo EQUS "\n\
    AccumulateArgs\n\
    ForwardToMacro "

DefineDefaultMacros: MACRO
    DEF CONTEXT_NAME EQUS "\1"
    SHIFT
    REPT _NARG
        DEF {CONTEXT_NAME}_\1 EQUS "Default_\1"
    ENDR
ENDM

DefineContextMacros: MACRO
    REPT _NARG
        DefineContextMacro \1
        SHIFT
    ENDR
ENDM
    DefineContextMacros Battle, Team
    DefineContextMacros switch, case, end
    DefineContextMacros text, asmtext, asmdone, done, prompt, exit
    DefineContextMacros Delay
