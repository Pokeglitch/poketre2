DEF ClassInstanceTableAddress = $4000
DEF CLASS_BANK = $30
Class: MACRO
    DEF \1Class = CLASS_BANK
    DEF CLASS_BANK = CLASS_BANK + 1
    
    SECTION "\1 Class", ROMX[ClassInstanceTableAddress], BANK[\1Class]
        db \1EntrySize

        Table \1
ENDM

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

Default_Flag: MACRO
    DEF {TABLE_NAME}\1\2 = 0
    DEF {TABLE_NAME}\1\3 = 1
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
; 3+? - Values
Prop: MACRO
    ; If this is the first time an entry is being defined, then update the table values
    IF {TABLE_NAME}EntryCount == 0
        DEF PROPERTY_INDEX = {TABLE_NAME}PropertyCount
        REDEF PROPERTY_BY_INDEX EQUS "{TABLE_NAME}Property{d:PROPERTY_INDEX}"

        REDEF PROPERTY_KEY EQUS "\1"
        REDEF PROPERTY_BY_KEY EQUS "{TABLE_NAME}Property\1"

        ; Map the Property Key to the Property by Index
        DEF {PROPERTY_BY_INDEX}Key EQUS "{PROPERTY_KEY}"

        ; Map the Property Index to the Property by Key
        DEF {PROPERTY_BY_KEY}Index = PROPERTY_INDEX


        ; Map the property offset (within the entry) to the Property
        DEF PROPERTY_OFFSET = {TABLE_NAME}EntrySize

        DEF {PROPERTY_BY_INDEX}Offset = PROPERTY_OFFSET
        DEF {PROPERTY_BY_KEY}Offset = PROPERTY_OFFSET

        ; If it is a list of Flags, then define variables for each bit
        IF STRCMP("\2", "Flags") == 0

            ; Map the Flag Count to the Property
            DEF FLAG_COUNT = (_NARG-2)/2
            DEF {PROPERTY_BY_INDEX}FlagCount = FLAG_COUNT
            DEF {PROPERTY_BY_KEY}FlagCount = FLAG_COUNT

            FOR FLAG_INDEX, FLAG_COUNT
                DEF FLAG_MASK = 1 << FLAG_INDEX
                DEF KEY_INDEX = FLAG_INDEX*2 + 3

                REDEF FLAG_KEY EQUS "\<{d:KEY_INDEX}>"
                REDEF FLAG_BY_INDEX EQUS "Flag{d:FLAG_INDEX}"
                REDEF FLAG_BY_KEY EQUS "Flag{FLAG_KEY}"


                ; Map the Flag Key to the Property, Flag By Index
                DEF {PROPERTY_BY_INDEX}{FLAG_BY_INDEX}Key EQUS "{FLAG_KEY}"
                DEF {PROPERTY_BY_KEY}{FLAG_BY_INDEX}Key EQUS "{FLAG_KEY}"

                ; Map the Flag Index to the Property, Flag by Key
                DEF {PROPERTY_BY_INDEX}{FLAG_BY_KEY}Index = FLAG_INDEX
                DEF {PROPERTY_BY_KEY}{FLAG_BY_KEY}Index = FLAG_INDEX

                ; Map the Flag Mask to the Property, Flag
                DEF {PROPERTY_BY_INDEX}{FLAG_BY_INDEX}Mask = FLAG_MASK
                DEF {PROPERTY_BY_INDEX}{FLAG_BY_KEY}Mask = FLAG_MASK
                DEF {PROPERTY_BY_KEY}{FLAG_BY_INDEX}Mask = FLAG_MASK
                DEF {PROPERTY_BY_KEY}{FLAG_BY_KEY}Mask = FLAG_MASK

                ; Map the Property Key to the Property by Index, Flag
                DEF {PROPERTY_BY_INDEX}{FLAG_BY_INDEX}PropertyKey EQUS "{PROPERTY_KEY}"
                DEF {PROPERTY_BY_INDEX}{FLAG_BY_KEY}PropertyKey EQUS "{PROPERTY_KEY}"
                
                ; Map the Property Index to the Property by Key, Flag
                DEF {PROPERTY_BY_KEY}{FLAG_BY_INDEX}PropertyIndex = PROPERTY_INDEX
                DEF {PROPERTY_BY_KEY}{FLAG_BY_KEY}PropertyIndex = PROPERTY_INDEX
                
                ; Map the Property Offset to the Property, Flag
                DEF {PROPERTY_BY_INDEX}{FLAG_BY_INDEX}PropertyOffset = PROPERTY_OFFSET
                DEF {PROPERTY_BY_INDEX}{FLAG_BY_KEY}PropertyOffset = PROPERTY_OFFSET
                DEF {PROPERTY_BY_KEY}{FLAG_BY_INDEX}PropertyOffset = PROPERTY_OFFSET
                DEF {PROPERTY_BY_KEY}{FLAG_BY_KEY}PropertyOffset = PROPERTY_OFFSET
            ENDR
        ENDC

        ; Increase the table entry size
        DEF {TABLE_NAME}EntrySize += \2Allocate

        ; Increase the table property count
        DEF {TABLE_NAME}PropertyCount += 1
    ENDC

    ; Accumulate the args to send to the definition macro
    REDEF PROP_ARGS_STR EQUS "{TABLE_NAME}, {ENTRY_NAME}, \1"
    FOR I, 3, _NARG+1
        REDEF PROP_ARGS_STR EQUS STRCAT("{PROP_ARGS_STR}", ", \<{d:I}>")
    ENDR

    ; Place the value
    \2Define {PROP_ARGS_STR}
ENDM

ByteAllocate EQU 1
WordAllocate EQU 2
FlagsAllocate EQU ByteAllocate
BCD2Allocate EQU 2 * ByteAllocate
BCD3Allocate EQU 3 * ByteAllocate
PointerAllocate EQU WordAllocate
StringAllocate EQU PointerAllocate
SpriteAllocate EQU WordAllocate + ByteAllocate + PointerAllocate

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

WordDefine: MACRO
    ; Define the value to an identifier
    DEF \1\2\3 = \4

    dw \4
ENDM

FlagsDefine: MACRO
    DEF FLAGS_BYTE = 0

    FOR FLAG_INDEX, (_NARG-3)/2
        DEF KEY_INDEX = FLAG_INDEX*2 + 4
        DEF VALUE_INDEX = KEY_INDEX + 1
        REDEF FLAG_KEY EQUS "\<{d:KEY_INDEX}>"
        DEF FLAG_VALUE = \1{FLAG_KEY}\<{d:VALUE_INDEX}>

        ; Define the flag's value to an identifier
        DEF \1\2\3{FLAG_KEY} = FLAG_VALUE

        ; Add to the Flag Value
        DEF SHIFTED_FLAG_VALUE = FLAG_VALUE << FLAG_INDEX
        DEF FLAGS_BYTE = FLAGS_BYTE | SHIFTED_FLAG_VALUE

    ENDR

    ; Define the combined flags byte to the identifier
    DEF \1\2\3 = FLAGS_BYTE

    db FLAGS_BYTE
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
        INCBIN STRCAT("pce/", "\1\3","/", STRLWR("\2"),".pce")
        \1\2\3End::
    POPS
ENDM

BCD3Define: MACRO
    ; Define the value to an identifier
    DEF \1\2\3 = \4

	dn ((\4) / 100000) % 10, ((\4) / 10000) % 10
	dn ((\4) / 1000) % 10, ((\4) / 100) % 10
	dn ((\4) / 10) % 10, (\4) % 10
ENDM

BCD2Define: MACRO
    ; Define the value to an identifier
    DEF \1\2\3 = \4

	dn ((\4) / 1000) % 10, ((\4) / 100) % 10
	dn ((\4) / 10) % 10, (\4) % 10
ENDM