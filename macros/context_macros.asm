Context EQUS "Default"
ContextSize = 0

PushContext: MACRO
    SetContext \1
    PUSHS
ENDM

SetContext: MACRO
    REDEF Context{d:ContextSize} EQUS "{Context}"
    REDEF Context EQUS "\1"
    DEF ContextSize += 1
ENDM

CloseContext: MACRO
    IF ContextSize
        DEF ContextSize -= 1
        REDEF Context EQUS "{Context{d:ContextSize}}"
    ENDC
ENDM

PopContext: MACRO
    IF ContextSize
        CloseContext
        POPS
    ENDC
ENDM

Battle: MACRO
    IF DEF({Context}_Battle)
        ; Accumulate the args to send to macro
        REDEF ARGS_STR EQUS ""
        REPT _NARG
            IF STRCMP("{ARGS_STR}", "") != 0
                REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", ", ")
            ENDC
            
            REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", "\1")
            SHIFT
        ENDR
        {Context}_Battle {ARGS_STR}
    ENDC
ENDM

Team: MACRO
    IF DEF({Context}_Team)
        ; Accumulate the args to send to macro
        REDEF ARGS_STR EQUS ""
        REPT _NARG
            IF STRCMP("{ARGS_STR}", "") != 0
                REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", ", ")
            ENDC
            
            REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", "\1")
            SHIFT
        ENDR
        {Context}_Team {ARGS_STR}
    ENDC
ENDM

switch: MACRO
    IF DEF({Context}_switch)
        ; Accumulate the args to send to macro
        REDEF ARGS_STR EQUS ""
        REPT _NARG
            IF STRCMP("{ARGS_STR}", "") != 0
                REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", ", ")
            ENDC
            
            REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", "\1")
            SHIFT
        ENDR
        {Context}_switch {ARGS_STR}
    ENDC
ENDM

case: MACRO
    IF DEF({Context}_case)
        ; Accumulate the args to send to macro
        REDEF ARGS_STR EQUS ""
        REPT _NARG
            IF STRCMP("{ARGS_STR}", "") != 0
                REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", ", ")
            ENDC
            
            REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", "\1")
            SHIFT
        ENDR
        {Context}_case {ARGS_STR}
    ENDC
ENDM

end: MACRO
    IF DEF({Context}_end)
        ; Accumulate the args to send to macro
        REDEF ARGS_STR EQUS ""
        REPT _NARG
            IF STRCMP("{ARGS_STR}", "") != 0
                REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", ", ")
            ENDC
            
            REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", "\1")
            SHIFT
        ENDR
        {Context}_end {ARGS_STR}
    ENDC
ENDM

Text: MACRO
    IF DEF({Context}_Text)
        ; Accumulate the args to send to macro
        REDEF ARGS_STR EQUS ""
        REPT _NARG
            IF STRCMP("{ARGS_STR}", "") != 0
                REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", ", ")
            ENDC
            
            REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", "\1")
            SHIFT
        ENDR
        {Context}_Text {ARGS_STR}
    ENDC
ENDM

Done: MACRO
    IF DEF({Context}_Done)
        ; Accumulate the args to send to macro
        REDEF ARGS_STR EQUS ""
        REPT _NARG
            IF STRCMP("{ARGS_STR}", "") != 0
                REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", ", ")
            ENDC
            
            REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", "\1")
            SHIFT
        ENDR
        {Context}_Done {ARGS_STR}
    ENDC
ENDM

Prompt: MACRO
    IF DEF({Context}_Prompt)
        ; Accumulate the args to send to macro
        REDEF ARGS_STR EQUS ""
        REPT _NARG
            IF STRCMP("{ARGS_STR}", "") != 0
                REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", ", ")
            ENDC
            
            REDEF ARGS_STR EQUS STRCAT("{ARGS_STR}", "\1")
            SHIFT
        ENDR
        {Context}_Prompt {ARGS_STR}
    ENDC
ENDM