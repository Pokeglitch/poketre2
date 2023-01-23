; TODO - Define by macro ?
PartyDataSpecialFlagIndex = 7
PartyDataSpecialFlagMask = %10000000
PartyDataTerminator = 0

Party: MACRO
    DEF SPECIAL_MASK = 0
    
    ; If there is a third argument, and it is a number, then it is special
    IF _NARG > 2
        REDEF ARG3 EQUS "\3"
        IsNumber {ARG3}

        IF IS_NUMBER == 1
            DEF SPECIAL_MASK = PartyDataSpecialFlagMask
        ENDC
    ENDC

    db SPECIAL_MASK | \1, \2
    SHIFT 2

    IF SPECIAL_MASK != 0
        REPT _NARG/2
            DEF SPECIAL_MASK = PartyDataSpecialFlagMask

            ; TODO - this DEF check is unncessary once the Move Table is added
            IF DEF(\2Table)
                IF STRCMP("{\2Table}","Pokemon") == 0
                    DEF SPECIAL_MASK = 0
                ENDC
            ENDC
            
            db SPECIAL_MASK | \1, \2
            SHIFT 2
        ENDR
    ELSE
        REPT _NARG
            db \1
            SHIFT
        ENDR
    ENDC

    db PartyDataTerminator
ENDM
