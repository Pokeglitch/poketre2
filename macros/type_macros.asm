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