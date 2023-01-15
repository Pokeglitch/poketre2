; TODO:
; Add way to auto create labels based on the table property name
; Ex
; Class$ -> will prepend to entry name
; $Count -> Will append to entry name
; Fill$Pixels will place it in middle
; use $1, $2, etc ???
; - will need separate way to handle more than 10 arguments...
;
; if one of the table entries is a string
; - initialize a string section fragment (with label)
;   - The bank can be an input agument into the table macro
; - in entry, if argument is string type:
; -- Place string to section, and place pointer in table
; 
; This functionality is already in "Class"...can it be combined with table?

REDEF TABLE_NAME EQUS ""
Table: MACRO
    ; Store the Table Name so the Entry macro can reference it
    REDEF TABLE_NAME EQUS "\1"
    SHIFT

    ; Initialize the table size
    DEF TABLE_SIZE = 0

    REPT _NARG/2
        ; Define the offset for this property
        DEF {TABLE_NAME}\1 = TABLE_SIZE

        ; Increase the table size
        DEF TABLE_SIZE += \2Allocate

        SHIFT 2
    ENDR

    ; Define the Size of the Table
    DEF {TABLE_NAME}Size = TABLE_SIZE
    ; Initialize the Count of the Table
    DEF {TABLE_NAME}Count = 0

    ; Create the table label
    {TABLE_NAME}Table:
ENDM

Entry: MACRO
    ; Define the index for this entry
    REDEF ENTRY_NAME EQUS "\1"
    DEF {TABLE_NAME}\1 = {TABLE_NAME}Count

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

    ; Increase the Table Size
    DEF {TABLE_NAME}Count += 1
ENDM

; Strip Out bad characters
DEF CLEANED_STRING EQUS ""
CleanString: MACRO
    REDEF CLEANED_STRING EQUS STRRPL("\1","♀","F")
    REDEF CLEANED_STRING EQUS STRRPL("{CLEANED_STRING}","♂","M")
    REDEF CLEANED_STRING EQUS STRRPL("{CLEANED_STRING}","é","e")
    REDEF CLEANED_STRING EQUS STRRPL("{CLEANED_STRING}","'","")
    REDEF CLEANED_STRING EQUS STRRPL("{CLEANED_STRING}",".","")
    REDEF CLEANED_STRING EQUS STRRPL("{CLEANED_STRING}"," ","")
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
    dw \1\2\3

    PUSHS
    SECTION FRAGMENT "ClassInstanceNames", ROMX, BANK[CLASSES_BANK]
    \1\2\3:
        str \4
    POPS
ENDM

SpriteDefine: MACRO
    dw \1\2\3End - \1\2\3
    dbw BANK(\1\2\3), \1\2\3

    PUSHS
    SECTION "\1\2\3", ROMX
        \1\2\3::
        INCBIN STRCAT("gfx/pce/", "\1\2","/", STRLWR("\3"),".pce")
        \1\2\3End::
    POPS
ENDM

ByteDefine: MACRO
    db \4
ENDM

PointerDefine: MACRO
    dw \4
ENDM

BankDefine: MACRO
    db BANK(\3)
ENDM

BankPointerDefine: MACRO
    dbw BANK(\3), \3
ENDM

Class: MACRO
    REDEF CLASS_NAME EQUS "\1"
    REDEF MACRO_ARGUMENTS EQUS ""
    REDEF NAME_ARGUMENTS EQUS ""
    SHIFT

    ; Reset the offset counter
    RSRESET
    ; Initialize the Name, which is a default property
    DEF {CLASS_NAME}Name RB StringAllocate

    ; Initialize the count of instances for this class
    DEF {CLASS_NAME}Count = 0

    DEF PROP_COUNT = 0
    REPT _NARG/2
        ; Define the constant ClassNamePropertyName to represent the offset from start of struct
        DEF {CLASS_NAME}\1 RB \2Allocate

        ; Add the name to the arguments
        REDEF NAME_ARGUMENTS EQUS STRCAT("{NAME_ARGUMENTS}", "\1, ")

        ; Add the definition macro to the arguments
        REDEF MACRO_ARGUMENTS EQUS STRCAT("{MACRO_ARGUMENTS}", "\2, ")

        DEF PROP_COUNT += 1
        SHIFT 2
    ENDR

    ; Define the Class Size
    DEF {CLASS_NAME}Size RB

    ; Create the Macro for this Class
    DEF {CLASS_NAME} EQUS STRCAT("Instantiate {CLASS_NAME}, {PROP_COUNT},", "{NAME_ARGUMENTS}", "{MACRO_ARGUMENTS}")


    ; Add this Class data to the table
    ; (label already defined in 'Entry')
    ByteDefine Class, Size, {CLASS_NAME}, {CLASS_NAME}Size
    PointerDefine Class, Instances, {CLASS_NAME}, {CLASS_NAME}Instances

    PUSHS
    ; Create the Class Instances Section
    SECTION "{CLASS_NAME}Instances", ROMX, BANK[CLASSES_BANK]
        {CLASS_NAME}Instances:
            INCLUDE STRCAT("classes/", STRLWR("{CLASS_NAME}"),".asm")
    POPS

ENDM

; \1 = Class Name
; \2 = Number of Properties
; First user property is the Instance Name
Instantiate: MACRO
    REDEF CLASS_NAME EQUS "\1"
    DEF PROP_COUNT = \2

    DEF PROP_NAME_START_INDEX = 3
    DEF MACRO_START_INDEX = PROP_NAME_START_INDEX + PROP_COUNT
    DEF ID_INDEX = MACRO_START_INDEX + PROP_COUNT
    DEF ARGUMENT_INDEX = ID_INDEX + 1

    IF ISCONST(\<{d:ID_INDEX}>)
        REDEF INSTANCE_NAME_STR EQUS "\<{d:ID_INDEX}>"

        CleanString {INSTANCE_NAME_STR}
        REDEF INSTANCE_NAME EQUS {CLEANED_STRING}
    ELSE
        REDEF INSTANCE_NAME EQUS "\<{d:ID_INDEX}>"
        REDEF INSTANCE_NAME_STR EQUS "\"{INSTANCE_NAME}\""
    ENDC
    
    {CLASS_NAME}{INSTANCE_NAME}Data:
        ; Initialize the Name
        StringDefine {CLASS_NAME}, Name, {INSTANCE_NAME}, {INSTANCE_NAME_STR}
        
        ; Define the ID and increase
        DEF {INSTANCE_NAME} = \1Count
        DEF \1Count += 1

        ; Parse the Properties
        FOR I, PROP_COUNT
            DEF PROP_NAME_INDEX = PROP_NAME_START_INDEX + I
            DEF MACRO_INDEX = MACRO_START_INDEX + I

            REDEF ARGUMENT_STRING EQUS ""
            REPT \<{d:MACRO_INDEX}>Args
                REDEF ARGUMENT_STRING EQUS STRCAT("{ARGUMENT_STRING}", ", \<{d:ARGUMENT_INDEX}>")
                DEF ARGUMENT_INDEX = ARGUMENT_INDEX + 1
            ENDR

            \<{d:MACRO_INDEX}>Define {CLASS_NAME}, \<{d:PROP_NAME_INDEX}>, {INSTANCE_NAME} {ARGUMENT_STRING}
        ENDR
ENDM