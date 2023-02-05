INCLUDE "macros/byte_struct.asm"

; 1 = how many bits to set
; 2 = how many bits to shift
BitMask: MACRO
    DEF BIT_MASK = 0
    REPT \1
        DEF BIT_MASK = (BIT_MASK << 1) | 1
    ENDR

    DEF BIT_MASK = BIT_MASK << \2
ENDM

CleanChar: MACRO
    IF _NARG == 3
        REDEF \1 EQUS STRRPL("{\1}", \2, \3)
    ELSE
        REDEF \1 EQUS STRRPL("{\1}", \2, "")
    ENDC
ENDM

MakeIdentifier: MACRO
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
ConvertName: MACRO
    REDEF NAME_VALUE EQUS "\1"
    REDEF NAME_STRING EQUS "\"\1\""
    MakeIdentifier NAME_VALUE
ENDM

StartsWithDigit: MACRO
    IF STRIN("\1","\2") == 1
        DEF IS_NUMBER = 1
    ENDC
ENDM

; todo - this wont work if \1 is an expression or symbol...
IsNumber: MACRO
    DEF IS_NUMBER = 0
    StartsWithDigit \1, 0
    StartsWithDigit \1, 1
    StartsWithDigit \1, 2
    StartsWithDigit \1, 3
    StartsWithDigit \1, 4
    StartsWithDigit \1, 5
    StartsWithDigit \1, 6
    StartsWithDigit \1, 7
    StartsWithDigit \1, 8
    StartsWithDigit \1, 9
    StartsWithDigit \1, -
    StartsWithDigit \1, $
    StartsWithDigit \1, &
    StartsWithDigit \1, %
    StartsWithDigit \1, `
ENDM

CheckIfRegister: MACRO
    IF STRCMP("\1", "\2") == 0
        DEF IS_REGISTER = 1
    ENDC
ENDM

IsRegister: MACRO
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
Default_Array: MACRO
	REDEF ARRAY_NAME EQUS "\1"
	SHIFT

	IsNumber \1
	IF IS_NUMBER
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

CheckOverload: MACRO
    DEF OVERLOAD = 0
    IF STRCMP("\1","-o") == 0
        DEF OVERLOAD = 1
        DEF ORIGINAL_VALUE = \2
        REDEF VALUE_NAME EQUS "\2"
    ENDC
ENDM

ResetOverload: MACRO
    DEF OVERLOAD = 0
    DEF OVERLOAD_END_VALUE = 0
ENDM

RestoreOverload: MACRO
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
