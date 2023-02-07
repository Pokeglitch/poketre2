INCLUDE "macros/context_macros.asm"
INCLUDE "macros/type_macros.asm"
INCLUDE "macros/data_macros.asm"

MACRO Class
    Table \1
ENDM

; Duplicate Table and Entry so the same class file can be used
MACRO Table
    ; Store the Table Name so the Entry macro can reference it
    REDEF TABLE_NAME EQUS "\1"
    ; Initialize the Count of the Table Entries
    DEF {TABLE_NAME}EntryCount = 0
ENDM

MACRO Default_Flag
    DEF {TABLE_NAME}\1\2 = 0
    DEF {TABLE_NAME}\1\3 = 1
ENDM

MACRO Entry
    ; Increase the table entry count
    DEF {TABLE_NAME}EntryCount += 1
ENDM