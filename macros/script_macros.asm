IgnoreButtons: MACRO
    DEF MASK_VALUE = 0
    REPT _NARG
        DEF MASK_VALUE += \1ButtonBitMask
        SHIFT
    ENDR

    StoreIntoRegister wJoyIgnore, {MASK_VALUE}
ENDM

PermitButtons: MACRO
    DEF MASK_VALUE = 0
    REPT _NARG
        DEF MASK_VALUE += \1ButtonBitMask
        SHIFT
    ENDR

    DEF MASK_VALUE ^= %11111111

    StoreIntoRegister wJoyIgnore, {MASK_VALUE}
ENDM

; todo - what if \1 is an expression or a symbol?
LoadIntoA: MACRO
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

LoadAIntoRegister: MACRO
    IsRegister \1
    IF IS_REGISTER
        IF STRCMP("\1","a") != 0
            ld \1, a
        ENDC
    ELSE
        ld [\1], a
    ENDC
ENDM

StoreIntoRegister: MACRO
    LoadIntoA \2
    LoadAIntoRegister \1
ENDM

; todo - handle multiple requirements?
Require: MACRO
    IF _NARG > 1
        LoadIntoA \1
        SHIFT
    ENDC

    cp \1
    ret nz
ENDM
