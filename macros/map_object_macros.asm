MapSignFlagIndex = 7
TrainerHeaderSize = 12
TrainerHeaderTermiantor = -1

    Array TextType, None, Item, Trainer

; TODO - define by macro
TextTypeShift = 5
TextTypeMask = %11100000

MapData: MACRO
    REDEF MAP_NAME EQUS "\1"
    DEF \1Height = \2
    DEF \1Width = \3

    DEF CUR_BANK = BANK(@)
    DEF OBJ_TEXT_COUNT = 0

    DEF \1TextCount = 0
    DEF \1TrainerCount = 0
    
    PUSHS
        SECTION FRAGMENT "\1 Trainer Headers", ROMX, BANK[CUR_BANK]
            \1TrainerHeaders:

        SECTION FRAGMENT "\1 Texts", ROMX, BANK[CUR_BANK]
            \1Texts:

        SECTION FRAGMENT "\1 Text Pointers", ROMX, BANK[CUR_BANK]
            \1TextPointers:

        SECTION FRAGMENT "\1 Objects", ROMX, BANK[CUR_BANK]
            \1Object:
                INCLUDE "data/mapObjects/\1.asm"
                ResetObjectText

        SECTION FRAGMENT "\1 Trainer Headers", ROMX, BANK[CUR_BANK]
	        db TrainerHeaderTermiantor
    POPS

    ; Restore Text Macro
    REDEF text EQUS "db "
ENDM

CloseObjectText: MACRO
    IF OBJ_TEXT_COUNT > 0
        IF OBJ_TEXT_COUNT > 2
            prompt
        ELSE
            done
        ENDC
    ENDC
ENDM

ResetObjectText: MACRO
    CloseObjectText

    ; If the previous object has three entries, then duplicate the last one
    ; (Trainer Header Win Text)
    IF OBJ_TEXT_COUNT == 3
        SECTION FRAGMENT "{MAP_NAME} Trainer Headers", ROMX, BANK[CUR_BANK]
            dw {POINTER_NAME}
    ENDC

    DEF OBJ_TEXT_COUNT = 0
ENDM

UpdateMapObject: MACRO
    ResetObjectText

    SECTION FRAGMENT "{MAP_NAME} Objects", ROMX, BANK[CUR_BANK]
        IF DEF({MAP_NAME}\1Count) == 0
            {MAP_NAME}\1s:
                IF _NARG == 1
                    ; writing it before it gets define will write the final value
                    db {MAP_NAME}\1Count
                ENDC

            DEF {MAP_NAME}\1Count = 1
        ELSE
            DEF {MAP_NAME}\1Count = {MAP_NAME}\1Count + 1
        ENDC
ENDM

AddTextPointer: MACRO
    PUSHS
    SECTION FRAGMENT "{MAP_NAME} Text Pointers", ROMX, BANK[CUR_BANK]
        dw \1
    POPS
    
    DEF {MAP_NAME}TextCount = {MAP_NAME}TextCount + 1

    IF _NARG == 2
        db {MAP_NAME}TextCount | \2 << TextTypeShift
    ELSE
        db {MAP_NAME}TextCount
    ENDC
ENDM

MapCoord: MACRO
	db \2 + 4
	db \1 + 4
ENDM

NPC: MACRO
    UpdateMapObject Sprite
    REDEF text EQUS "MapText "

	db \1
	MapCoord \2, \3
	db \4
	db \5
    
    IF _NARG == 6
        AddTextPointer \6
    ENDC
ENDM

Battle: MACRO
    UpdateMapObject Sprite
    REDEF text EQUS "TrainerText "

    DEF TRAINER_INDEX = {MAP_NAME}TrainerCount
    REDEF POINTER_NAME EQUS "{MAP_NAME}TrainerHeader{d:TRAINER_INDEX}"

	db \1
	MapCoord \2, \3
	db \4
	db \5

    AddTextPointer {POINTER_NAME}, TextTypeTrainer
    
	db \6
	db \7 | ObjectDataTrainerFlagMask

    PUSHS
    SECTION FRAGMENT "{MAP_NAME} Trainer Headers", ROMX, BANK[CUR_BANK]
        {POINTER_NAME}:
            dbEventFlagBit EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_{d:TRAINER_INDEX}
            db (\8 << 4) ; trainer's view range
            dwEventFlagAddress EVENT_BEAT_VIRIDIAN_FOREST_TRAINER_{d:TRAINER_INDEX}
    POPS
    
    DEF {MAP_NAME}TrainerCount = {MAP_NAME}TrainerCount + 1
ENDM

Pickup: MACRO
    UpdateMapObject Sprite
    REDEF text EQUS "MapText "

	db SPRITE_BALL
	MapCoord \1, \2
	db STAY
	db NONE

    db TextTypeItem << TextTypeShift
    
    db \3

	IF _NARG == 4
		db \4
	ELSE
		db 1
	ENDC
ENDM

;\1 x position
;\2 y position
;\3 sign id
Sign: MACRO
    UpdateMapObject Sign
    REDEF text EQUS "MapText "

    db \2
    db \1
    IF _NARG == 3
        AddTextPointer \3
    ENDC
ENDM

;\1 x position
;\2 y position
;\3 destination warp id
;\4 destination map (-1 = wLastMap)
Warp: MACRO
    UpdateMapObject Warp

	db \2
    db \1
    db \3

    IF _NARG == 4
	    db \4
    ELSE
        db -1
    ENDC
ENDM

;\1 x position
;\2 y position
WarpTo: MACRO
    UpdateMapObject WarpTo, 0
    
	EVENT_DISP {MAP_NAME}Width, \2, \1
ENDM

AddText: MACRO
    DEF OBJ_TEXT_COUNT = OBJ_TEXT_COUNT + 1

    SECTION FRAGMENT "{MAP_NAME} Texts", ROMX, BANK[CUR_BANK]
        {POINTER_NAME}:
ENDM

MapText: MACRO
    REDEF POINTER_NAME EQUS "{MAP_NAME}Text{d:{MAP_NAME}TextCount}"

    ; Place the Pointer to the table
    AddTextPointer {POINTER_NAME}

    AddText
    REPT _NARG
        db \1
        SHIFT
    ENDR
ENDM

TrainerText: MACRO
    CloseObjectText

    REDEF POINTER_NAME EQUS "{MAP_NAME}Trainer{d:TRAINER_INDEX}Text{d:OBJ_TEXT_COUNT}"
    
    SECTION FRAGMENT "{MAP_NAME} Trainer Headers", ROMX, BANK[CUR_BANK]
        dw {POINTER_NAME}

    AddText
    REPT _NARG
        db \1
        SHIFT
    ENDR
ENDM