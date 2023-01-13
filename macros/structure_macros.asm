; If the arguments are arranged in order they have been written to the ROM
; It will combing loading for those that are next to each other
DEF TILE_ID = 0
DEF PREFIX EQUS ""
load_tiles: MACRO
    ; Update the TILE_ID if first argument is positive
    IF \1 > -1
        DEF TILE_ID = \1
    ENDC

    REDEF PREFIX EQUS "\2"

    SHIFT 2

    DEF TOTAL_TILES_COUNT = 0
    DEF START_TILE_ID = -1
    REDEF START_TILE_ADDRESS EQUS ""

    REPT _NARG
        ; If there is a next tile, see if its Previous is this
        IF _NARG > 1
            IF \1TilesIsGroup == 1
                REDEF THIS_TILE_NAME EQUS "{\1TilesLast}"
            ELSE
                REDEF THIS_TILE_NAME EQUS "\1Tiles"
            ENDC

            IF \2TilesIsGroup == 1
                REDEF NEXT_TILES_PREV EQUS "{{\2TilesFirst}Previous}"
            ELSE
                REDEF NEXT_TILES_PREV EQUS "{\2TilesPrevious}"
            ENDC 
            DEF DONT_COMBINE = STRCMP("{THIS_TILE_NAME}","{NEXT_TILES_PREV}")
        ELSE
            DEF DONT_COMBINE = 1
        ENDC

        DEF TILES_COUNT = \1TilesSize
        DEF TOTAL_TILES_COUNT += TILES_COUNT

        ; If combining, set the START_TILE_ID, Address if necessary
        IF DONT_COMBINE == 0
            IF START_TILE_ID == -1
                DEF START_TILE_ID = TILE_ID
                REDEF START_TILE_ADDRESS EQUS "\1Tiles"
            ENDC
        ; If not combining, then place the code
        ELSE
            ; If wasn't previously combining, then use the current tile
            IF START_TILE_ID == -1
                ld hl, vTiles + (TILE_ID * BYTES_PER_TILE)
                lb bc, BANK(\1Tiles), TILES_COUNT
                ld de, \1Tiles

            ; otherwise, use the tile from when combining started
            ELSE
                ld hl, vTiles + (START_TILE_ID * BYTES_PER_TILE)
                lb bc, BANK(START_TILE_ADDRESS), TOTAL_TILES_COUNT
                ld de, START_TILE_ADDRESS
            ENDC
            call CopyVideoData

            ; Reset the total tiles count
            DEF TOTAL_TILES_COUNT = 0
            ; Reset the Start Tile ID
            DEF START_TILE_ID = -1
            REDEF START_TILE_ADDRESS EQUS ""
        ENDC

        DEF CHILDREN_COUNT = \1TilesCount

        IF CHILDREN_COUNT > 0
            FOR I, 0, CHILDREN_COUNT
                REDEF {PREFIX}\1{\1Tiles{d:I}}Tile EQU TILE_ID
                DEF TILE_ID += \1{\1Tiles{d:I}}TilesSize
            ENDR
        ELSE
            REDEF {PREFIX}\1Tile EQU TILE_ID
            DEF TILE_ID += TILES_COUNT
        ENDC
        SHIFT
    ENDR
ENDM

DEF PREVIOUS_TILE EQUS ""
ResetPreviousTile: MACRO
    REDEF PREVIOUS_TILE EQUS ""
ENDM

IncludeTiles: MACRO
    ; Initialize the Main Size
    DEF \1TilesSize = 0

    ; Initialize the number of tile groups
    DEF \1TilesCount = 0

    ; Store this as a Group
    DEF \1TilesIsGroup = 1

    ; Initialize this 'First' to be empty
    DEF \1TilesFirst EQUS ""
    
    ; Create the main label
    \1Tiles:
        FOR I, 1, (_NARG+1)/2
            DEF TILE_NAME_INDEX = I*2
            DEF TILE_SIZE_INDEX = I*2+1
            ; Store the size (in Tiles)
            DEF \1\<TILE_NAME_INDEX>TilesSize = \<TILE_SIZE_INDEX>
            ; Set the count to 0
            DEF \1\<TILE_NAME_INDEX>TilesCount = 0
            ; Store this as NOT a group
            DEF \1\<TILE_NAME_INDEX>TilesIsGroup = 0

            ; Create the child Label
            \1\<TILE_NAME_INDEX>Tiles: INCBIN STRCAT("gfx/", "\1", "/", "\<TILE_NAME_INDEX>", ".2bpp")
        
            ; Update the Main Size
            DEF \1TilesSize += \<TILE_SIZE_INDEX>

            ; Map this name to the Index
            DEF \1Tiles{d:\1TilesCount} EQUS "\<TILE_NAME_INDEX>"

            ; Store this PreviousTile
            DEF \1\<TILE_NAME_INDEX>TilesPrevious EQUS "{PREVIOUS_TILE}"

            ; Store this as the Previous Tile
            REDEF PREVIOUS_TILE EQUS "\1\<TILE_NAME_INDEX>Tiles"

            ; Store this as groups first tile, if it is
            IF STRCMP("{\1TilesFirst}", "") == 0
                REDEF \1TilesFirst EQUS "\1\<TILE_NAME_INDEX>Tiles"
            ENDC

            ; Update the number of tiles
            DEF \1TilesCount += 1
        ENDR

    ; Store Previous Tile as this Last Tile
    DEF \1TilesLast EQUS "{PREVIOUS_TILE}"
ENDM

Table: MACRO
    DEF TABLE_SIZE = 0

    FOR I, 2, _NARG+1
        DEF TABLE_SIZE += \<I>Allocate
    ENDR

    ; Define the Size of the Table
    DEF \1Size = TABLE_SIZE
    ; Initialize the Count of the Table
    DEF \1Count = 0
    ; Create the table pointer
    \1Table:
ENDM

CLASSES_BANK EQU $2D

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

    ; Define the Class ID
    DEF {CLASS_NAME}Class = ClassCount

    ; Define the Class Size
    DEF {CLASS_NAME}Size RB

    ; Create the Macro for this Class
    DEF {CLASS_NAME} EQUS STRCAT("Instantiate {CLASS_NAME}, {PROP_COUNT},", "{NAME_ARGUMENTS}", "{MACRO_ARGUMENTS}")


    ; Add this Class data to the table
    Class{CLASS_NAME}:
        ByteDefine Class, Size, {CLASS_NAME}, {CLASS_NAME}Size
        PointerDefine Class, Instances, {CLASS_NAME}, {CLASS_NAME}Instances

    PUSHS
    ; Create the Class Instances Section
    SECTION "{CLASS_NAME}Instances", ROMX, BANK[CLASSES_BANK]
        {CLASS_NAME}Instances:
            INCLUDE STRCAT("classes/", STRLWR("{CLASS_NAME}"),".asm")
    POPS

    DEF ClassCount += 1
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

        ; Strip Out bad characters
        REDEF INSTANCE_NAME EQUS STRRPL("{INSTANCE_NAME_STR}","♀","F")
        REDEF INSTANCE_NAME EQUS STRRPL("{INSTANCE_NAME}","♀","F")
        REDEF INSTANCE_NAME EQUS STRRPL("{INSTANCE_NAME}","♂","M")
        REDEF INSTANCE_NAME EQUS STRRPL("{INSTANCE_NAME}","é","e")
        REDEF INSTANCE_NAME EQUS STRRPL("{INSTANCE_NAME}","'","")
        REDEF INSTANCE_NAME EQUS STRRPL("{INSTANCE_NAME}",".","")
        REDEF INSTANCE_NAME EQUS STRRPL("{INSTANCE_NAME}"," ","")
        REDEF INSTANCE_NAME EQUS {INSTANCE_NAME}
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