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
Array: MACRO
	REDEF ARRAY_NAME EQUS "\1"
	SHIFT

	IsNumber \1
	IF IS_NUMBER
        ; If the array has already  been defined, print the message
        IF DEF({ARRAY_NAME}Size) == 1
            PRINT "Warning: Array {ARRAY_NAME} has already been defined. Not changing starting index"
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

; creates BitIndex and BitMask
; can skip bits if number
Bits: MACRO
    DEF BIT_INDEX = 0
    DEF ALL_MASK_VALUE = 0
    REDEF BIT_TYPE EQUS "\1"
    SHIFT

    REPT _NARG
        IsNumber \1
        IF IS_NUMBER
            DEF BIT_INDEX += \1
        ELSE
            DEF \1{BIT_TYPE}BitIndex = BIT_INDEX
            DEF \1{BIT_TYPE}BitMask = 1 << BIT_INDEX
            DEF ALL_MASK_VALUE += \1{BIT_TYPE}BitMask
            DEF BIT_INDEX += 1
        ENDC
        SHIFT
    ENDR

    DEF All{BIT_TYPE}BitMask = ALL_MASK_VALUE
    DEF None{BIT_TYPE}BitMask = %11111111 ^ ALL_MASK_VALUE
ENDM

; 1: name
; 2: type
Mask: MACRO
    DEF MASK_VALUE = 0
    REDEF MASK_NAME EQUS "\1"
    REDEF BIT_TYPE EQUS "\2"
    SHIFT 2

    REPT _NARG
        DEF MASK_VALUE += \1{BIT_TYPE}BitMask
        SHIFT
    ENDR

    DEF {MASK_NAME}{BIT_TYPE}BitMask = MASK_VALUE
ENDM