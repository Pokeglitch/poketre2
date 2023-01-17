INCLUDE "macros/data_macros.asm"

; Duplicate Table and Entry so the same class file can be used
Table: MACRO
    ; Store the Table Name so the Entry macro can reference it
    REDEF TABLE_NAME EQUS "\1"
    ; Initialize the Count of the Table Entries
    DEF {TABLE_NAME}EntryCount = 0
ENDM

Entry: MACRO
    ; Increase the table entry count
    DEF {TABLE_NAME}EntryCount += 1
ENDM