DEF TILE_ID = 0

; Arguments:
; 1 - Tile ID to load into
; 2 - Number of Tiles to load
; 3 - Start address of tiles
MACRO load_vram
    ld hl, vTiles + (\1 * BYTES_PER_TILE)
    lb bc, BANK(\3), \2
    ld de, \3
    call CopyVideoData
ENDM

; Arguments
; 1 - Screen Name
; 2 - File Name
MACRO define_tile_ids
    REDEF \1\2Tile EQU TILE_ID

    FOR TILE_INDEX, 0, \2Size
        REDEF \1\2Tile_{d:TILE_INDEX} EQU TILE_ID
        DEF TILE_ID += 1
        
        IF TILE_INDEX == 0
            REDEF \1\2Tiles EQUS "{\1\2Tile_0}"
        ELSE
            REDEF \1\2Tiles EQUS "{\1\2Tiles}, {\1\2Tile_{d:TILE_INDEX}}"
        ENDC
    ENDR
ENDM

; Arguments
; - Starting Tile ID (-1 will use previous tile id)
; - Screen Name
;
; If the arguments are arranged in order they have been written to the ROM
; It will combine loading for those that are next to each other
MACRO load_tiles
    ; Update the TILE_ID if first argument is positive
    IF \1 > -1
        DEF TILE_ID = \1
    ENDC

    REDEF SCREEN EQUS "\2"

    SHIFT 2

    DEF PREVIOUS_SIZE = 0

    REPT _NARG
        ; If there is a next tile, combine if its Previous is this
        IF _NARG > 1
            ; If loading a directory, get the name of the last file in the directory
            IF \1ChildCount > 0
                DEF LAST_INDEX = \1ChildCount - 1
                REDEF THIS_NAME EQUS "\1{\1Tiles{d:LAST_INDEX}}Tiles"
            ELSE
                REDEF THIS_NAME EQUS "\1Tiles"
            ENDC

            ; If next is a directory, get the previous of the first file in that directory
            IF \2ChildCount > 0
                REDEF NEXTS_PREV EQUS "{\2{\2Tiles0}Previous}"
            ELSE
                REDEF NEXTS_PREV EQUS "{\2Previous}"
            ENDC
            DEF DONT_COMBINE = STRCMP("{THIS_NAME}","{NEXTS_PREV}")
        ELSE
            DEF DONT_COMBINE = 1
        ENDC

        ; If combining:
        IF DONT_COMBINE == 0
            ; If wasnt previously combining, set the start tile id and address
            IF PREVIOUS_SIZE == 0
                DEF START_TILE_ID = TILE_ID
                REDEF START_TILE_ADDRESS EQUS "\1Tiles"
            ENDC

            ; Update the total number of tiles to load
            DEF PREVIOUS_SIZE += \1Size

        ; If not combining, then place the code to load
        ELSE
            ; If wasn't previously combining, then use the current tile
            IF PREVIOUS_SIZE == 0
                load_vram TILE_ID, \1Size, \1Tiles
            ; otherwise, use the tile from when combining started
            ELSE
                load_vram START_TILE_ID, PREVIOUS_SIZE+\1Size, START_TILE_ADDRESS
            ENDC

            ; Reset the previous size
            DEF PREVIOUS_SIZE = 0
        ENDC

        ; If it is a directory, define tiles for all of the children
        IF \1ChildCount > 0
            FOR CHILD_INDEX, 0, \1ChildCount
                define_tile_ids {SCREEN}, \1{\1Tiles{d:CHILD_INDEX}}
            ENDR
        ; Otherwise, define the tiles for this
        ELSE
            define_tile_ids {SCREEN}, \1
        ENDC
        SHIFT
    ENDR
ENDM

DEF PREVIOUS_TILE EQUS ""
MACRO ResetPreviousTile
    REDEF PREVIOUS_TILE EQUS ""
ENDM

; Arguments:
; 1 - Directory Name
; - Repeating:
; - 1 - File Name
; - 2 - File Size (in Tiles) | Optional
MACRO IncludeTiles
    REDEF DIR EQUS "\1"
    SHIFT

    ; Initialize the Directory Size
    DEF {DIR}Size = 0

    ; Initialize the number of children
    DEF {DIR}ChildCount = 0
    
    ; Create the Directory label
    {DIR}Tiles:
        REPT _NARG
            IF _NARG > 0
                REDEF FILE EQUS "\1"
                SHIFT

                IF _NARG > 0
                    is#Number \1
                    IF so
                        DEF SIZE = \1
                        SHIFT
                    ELSE
                        DEF SIZE = 1
                    ENDC
                ENDC

                ; Store the size
                DEF {DIR}{FILE}Size = SIZE

                ; Update the Directory Size
                DEF {DIR}Size += SIZE

                ; Create the File Label and include the file
                {DIR}{FILE}Tiles:
                    INCBIN STRCAT("tiles/", "{DIR}", "/", "{FILE}", ".2bpp")
            
                ; Store the PreviousTile to this
                DEF {DIR}{FILE}Previous EQUS "{PREVIOUS_TILE}"

                ; Store this as the Previous Tile
                REDEF PREVIOUS_TILE EQUS "{DIR}{FILE}Tiles"

                ; Set the number of children to 0
                DEF {DIR}{FILE}ChildCount = 0
                
                ; Map this name to the Index of the Directory
                DEF {DIR}Tiles{d:{DIR}ChildCount} EQUS "{FILE}"

                ; Update the number of files in the directory
                DEF {DIR}ChildCount += 1
            ENDC
        ENDR
ENDM