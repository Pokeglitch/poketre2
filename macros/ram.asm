INCLUDE "macros/data_macros.asm"
INCLUDE "macros/type_macros.asm"

Class: MACRO
    Table \1
ENDM

; Duplicate Table and Entry so the same class file can be used
Table: MACRO
    ; Store the Table Name so the Entry macro can reference it
    REDEF TABLE_NAME EQUS "\1"
    ; Initialize the Count of the Table Entries
    DEF {TABLE_NAME}EntryCount = 0
ENDM

Flag: MACRO
    DEF {TABLE_NAME}\1\2 = 0
    DEF {TABLE_NAME}\1\3 = 1
ENDM

Entry: MACRO
    ; Increase the table entry count
    DEF {TABLE_NAME}EntryCount += 1
ENDM