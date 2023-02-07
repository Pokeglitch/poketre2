MACRO IgnoreButtons
    DEF MASK_VALUE = 0
    REPT _NARG
        DEF MASK_VALUE += Button\1BitMask
        SHIFT
    ENDR

    StoreIntoRegister wJoyIgnore, {MASK_VALUE}
ENDM

MACRO PermitButtons
    DEF MASK_VALUE = 0
    REPT _NARG
        DEF MASK_VALUE += Button\1BitMask
        SHIFT
    ENDR

    DEF MASK_VALUE ^= %11111111

    StoreIntoRegister wJoyIgnore, {MASK_VALUE}
ENDM

; todo - what if \1 is an expression or a symbol?
MACRO LoadIntoA
    IsRegister \1
    IF IS_REGISTER
        IF STRCMP("\1","a") != 0
            ld a, \1
        ENDC
    ELSE
        IsNumber \1
        IF IS_NUMBER
            IF \1 == 0
                xor a
            ELSE
                ld a, \1
            ENDC
        ELSE
            ld a, [\1]
        ENDC
    ENDC
ENDM

MACRO LoadAIntoRegister
    IsRegister \1
    IF IS_REGISTER
        IF STRCMP("\1","a") != 0
            ld \1, a
        ENDC
    ELSE
        ld [\1], a
    ENDC
ENDM

MACRO StoreIntoRegister
    LoadIntoA \2
    LoadAIntoRegister \1
ENDM

; todo - handle multiple requirements?
MACRO Require
    IF _NARG > 1
        LoadIntoA \1
        SHIFT
    ENDC

    cp \1
    ret nz
ENDM

MACRO DisplayText
    ld hl, \1
    call DisplayTextInTextbox
ENDM