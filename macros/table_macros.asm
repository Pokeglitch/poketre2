REDEF TABLE_NAME EQUS ""
; 1 - Table Name
Table: MACRO
    ; Store the Table Name so the Entry macro can reference it
    REDEF TABLE_NAME EQUS "\1"

    SHIFT

    ; Initialize the Count of the Table Entries
    DEF {TABLE_NAME}EntryCount = 0

    ; Initialize the Count of the Table Properties
    DEF {TABLE_NAME}PropertyCount = 0

    ; Initialize the table entry size
    DEF {TABLE_NAME}EntrySize = 0

    ; Create the table label
    {TABLE_NAME}Table:
ENDM

Entry: MACRO
    REDEF ENTRY_NAME EQUS "\1"
    MakeIdentifier ENTRY_NAME

    ; Define the index for this entry
    DEF {TABLE_NAME}{ENTRY_NAME} = {TABLE_NAME}EntryCount

    ; Define this entry without the Table Name (unless its already been defined)
    ; Also map it to the table
    IF DEF({ENTRY_NAME}) == 0
        DEF {ENTRY_NAME} = {TABLE_NAME}EntryCount
        DEF {ENTRY_NAME}Table EQUS "{TABLE_NAME}"
    ENDC

    ; Accumulate the arguments to forwards to the macro
    REDEF ENTRY_ARGUMENTS EQUS ""
    REPT _NARG
        IF STRCMP("{ENTRY_ARGUMENTS}", "") == 0
            REDEF ENTRY_ARGUMENTS EQUS " \1"
        ELSE
            REDEF ENTRY_ARGUMENTS EQUS STRCAT("{ENTRY_ARGUMENTS}", ", \1")
        ENDC
        SHIFT
    ENDR

    ; Create the entry label
    {TABLE_NAME}{ENTRY_NAME}Entry:
        ; Call the Macro
        TABLE_NAME {ENTRY_ARGUMENTS}

    ; Increase the table entry count
    DEF {TABLE_NAME}EntryCount += 1
ENDM

; 1 - Key
; 2 - Type
; 3 - Value
Prop: MACRO
    ; If this is the first time an entry is being defined, then update the table values
    IF {TABLE_NAME}EntryCount == 0
        ; Define the index & offset for this property (by Name and by Index)
        DEF {TABLE_NAME}Property{d:{TABLE_NAME}PropertyCount}Key EQUS "\1"
        DEF {TABLE_NAME}Property\1Index = {TABLE_NAME}PropertyCount
        DEF {TABLE_NAME}Property{d:{TABLE_NAME}PropertyCount}Offset = {TABLE_NAME}EntrySize
        DEF {TABLE_NAME}Property\1Offset = {TABLE_NAME}EntrySize

        ; Increase the table entry size
        DEF {TABLE_NAME}EntrySize += \2Allocate

        ; Increase the table property count
        DEF {TABLE_NAME}PropertyCount += 1
    ENDC

    ; Accumulate the args to send to the definition macro
    REDEF PROP_ARGS_STR EQUS "{TABLE_NAME}, {ENTRY_NAME}, \1"
    FOR I, 3, 3+\2Args
        REDEF PROP_ARGS_STR EQUS STRCAT("{PROP_ARGS_STR}", ", \<{d:I}>")
    ENDR
    ; Place the value
    \2Define {PROP_ARGS_STR}
ENDM

ByteAllocate EQU 1
WordAllocate EQU 2
PointerAllocate EQU WordAllocate
StringAllocate EQU PointerAllocate
BankAllocate EQU ByteAllocate
BankPointerAllocate EQU BankAllocate + PointerAllocate
SizeAllocate EQU WordAllocate
SpriteAllocate EQU SizeAllocate + BankPointerAllocate

PointerArgs = 1
StringArgs = 1
ByteArgs = 1
BankArgs = 1
BankPointerArgs = 1
SizeArgs = 1
SpriteArgs = 0

StringDefine: MACRO
    ; Define the value to an identifier
    DEF \1\2\3 EQUS \4

    ; Place the Pointer to the table
    dw \1\2\3String

    ; Place the String to the ROM
    DEF CUR_BANK = BANK(@)
    PUSHS
    SECTION FRAGMENT "Bank {CUR_BANK} Strings", ROMX, BANK[CUR_BANK]
    \1\2\3String:
        str \4
    POPS
ENDM

ByteDefine: MACRO
    ; Define the value to an identifier
    DEF \1\2\3 = \4

    db \4
ENDM

PointerDefine: MACRO
    ; Define the value to an identifier
    DEF \1\2\3 EQUS "\4"

    dw \4
ENDM

; TODO - what to define to idenfitier?
SpriteDefine: MACRO
    dw \1\2\3End - \1\2\3
    dbw BANK(\1\2\3), \1\2\3

    PUSHS
    SECTION "\1\2\3", ROMX
        \1\2\3::
        INCBIN STRCAT("gfx/pce/", "\1\3","/", STRLWR("\2"),".pce")
        \1\2\3End::
    POPS
ENDM

; TODO - what to define to idenfitier?
BankDefine: MACRO
    db BANK(\3)
ENDM

; TODO - what to define to idenfitier?
BankPointerDefine: MACRO
    dbw BANK(\3), \3
ENDM
