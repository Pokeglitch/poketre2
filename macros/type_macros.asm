INCLUDE "macros/byte_struct.asm"

; 1 = how many bits to set
; 2 = how many bits to shift
macro BitMask
    def temp#bitmask = 0
    rept \1
        def temp#bitmask = (temp#bitmask << 1) | 1
    endr

    return temp#bitmask << \2
endm

MACRO CleanChar
    IF _NARG == 3
        REDEF \1 EQUS STRRPL("{\1}", \2, \3)
    ELSE
        REDEF \1 EQUS STRRPL("{\1}", \2, "")
    ENDC
ENDM

MACRO MakeIdentifier
    ; normalize characters
    CleanChar \1, "♀", "F"
    CleanChar \1, "♂", "M"
    CleanChar \1, "é", "e"
    ; remove characters
    CleanChar \1, "'"
    CleanChar \1, "."
    CleanChar \1, " "
ENDM

; Get the name as a string and as an identifier safe value
MACRO ConvertName
    REDEF NAME_VALUE EQUS "\1"
    REDEF NAME_STRING EQUS "\"\1\""
    MakeIdentifier NAME_VALUE
ENDM

MACRO CheckIfRegister
    IF STRCMP("\1", "\2") == 0
        DEF IS_REGISTER = 1
    ENDC
ENDM

MACRO IsRegister
    DEF IS_REGISTER = 0
    CheckIfRegister \1, a
    CheckIfRegister \1, b
    CheckIfRegister \1, c
    CheckIfRegister \1, d
    CheckIfRegister \1, e
    CheckIfRegister \1, h
    CheckIfRegister \1, l
    CheckIfRegister \1, [hl]
ENDM

; makes a virtual list starting at 0 (or, optionally different value)
MACRO _Array
	REDEF ARRAY_NAME EQUS "\1"
	SHIFT

	is#Number \1
	IF so
        ; If the array has already been defined, fail
        IF DEF({ARRAY_NAME}Size) == 1
            FAIL "Array {ARRAY_NAME} has already been defined. Not changing starting index"
        ELSE
            DEF {ARRAY_NAME}FirstIndex = \1
            DEF {ARRAY_NAME}LastIndex = \1 - 1
            DEF {ARRAY_NAME}Size = 0
        ENDC

		SHIFT
	ELSE
        ; If this array has not already been defined, then initialize
        IF DEF({ARRAY_NAME}Size) == 0
            DEF {ARRAY_NAME}FirstIndex = 0
            DEF {ARRAY_NAME}LastIndex = -1
            DEF {ARRAY_NAME}Size = 0
        ENDC
	ENDC
	
    DEF ARRAY_INDEX = {ARRAY_NAME}LastIndex+1

	REPT _NARG
		DEF {ARRAY_NAME}\1 = ARRAY_INDEX
        DEF {ARRAY_NAME}{d:ARRAY_INDEX} EQUS "\1"

        DEF {ARRAY_NAME}LastIndex = {ARRAY_NAME}LastIndex + 1
		DEF {ARRAY_NAME}Size = {ARRAY_NAME}Size + 1
        DEF ARRAY_INDEX = ARRAY_INDEX + 1
		SHIFT
	ENDR
ENDM

MACRO CheckOverload
    DEF OVERLOAD = 0
    IF STRCMP("\1","-o") == 0
        DEF OVERLOAD = 1
        DEF ORIGINAL_VALUE = \2
        REDEF VALUE_NAME EQUS "\2"
    ENDC
ENDM

MACRO ResetOverload
    DEF OVERLOAD = 0
    DEF OVERLOAD_END_VALUE = 0
ENDM

MACRO RestoreOverload
    IF OVERLOAD
        ; store the end value for when overload is finished
        IF {VALUE_NAME} > OVERLOAD_END_VALUE
            DEF OVERLOAD_END_VALUE = {VALUE_NAME}
        ENDC
        DEF {VALUE_NAME} = ORIGINAL_VALUE
    ELSE
        IF OVERLOAD_END_VALUE
            IF {VALUE_NAME} < OVERLOAD_END_VALUE
                DEF {VALUE_NAME} = OVERLOAD_END_VALUE
            ENDC
        ENDC
    ENDC
ENDM
