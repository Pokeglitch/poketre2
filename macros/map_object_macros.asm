    ByteStruct MapObject
        Index TextIndex, 127    
        Flag Sign
        
    ByteStruct ObjectData
        Index -o, Level, 100
        Index PartyIndex, 127
        Flag Trainer

    ByteStruct MapText
        Index Index, 31
        Array Type, 3, Standard, Item, Trainer

; todo - struct macro
TrainerHeaderPropertyFlagIndexMask = %00000111
TrainerHeaderPropertyFlagAddressOffset = 2
TrainerHeaderPropertyBeforeBattleTextOffset = 4
TrainerHeaderPropertyAfterBattleTextOffset = 6
TrainerHeaderPropertyWinBattleTextOffset = 8
TrainerHeaderPropertyLoseBattleTextOffset = 10
TrainerHeaderSize = 12
TrainerHeaderTerminator = -1

TotalTrainerBattleCount = 0

; 1: Name
; 2: Height
; 3: Width
; 4: Tileset
; 5: Border Block
MapData: MACRO
    REDEF MAP_NAME EQUS "\1"
    DEF \1Height = \2
    DEF \1Width = \3
    DEF \1Tileset = \4
    DEF \1Border = \5

    DEF CUR_BANK = BANK(@)

    DEF \1TextCount = 0
    DEF \1BattleCount = 0

    PUSHS
        SetContext MapScript
        SECTION FRAGMENT "\1 Script", ROMX, BANK[CUR_BANK]
            INCLUDE "scripts/\1.asm"
        CloseContext

        SECTION FRAGMENT "\1 Header", ROMX, BANK[CUR_BANK]
            \1Header:
                db \1Tileset
                db \1Height, \1Width
                dw \1Blocks, \1TextPointers, \1Script, \1TrainerHeaders
                db \1ConnectionFlags

            ; define after allocating so it uses final value
            DEF \1ConnectionFlags = 0

        SECTION FRAGMENT "\1 Trainer Headers", ROMX, BANK[CUR_BANK]
            \1TrainerHeaders:

        SECTION FRAGMENT "\1 Texts", ROMX, BANK[CUR_BANK]
            \1Texts:

        SECTION FRAGMENT "\1 Text Pointers", ROMX, BANK[CUR_BANK]
            \1TextPointers:

        SetContext MapObjects
        SECTION FRAGMENT "\1 Objects", ROMX, BANK[CUR_BANK]
            \1Objects:
                db \1Border
                INCLUDE "data/mapObjects/\1.asm"
        CloseContext

        SECTION FRAGMENT "\1 Trainer Headers", ROMX, BANK[CUR_BANK]
	        db TrainerHeaderTerminator

        SECTION "\1 Blocks", ROMX, BANK[CUR_BANK]
            \1Blocks:
                INCBIN STRCAT("maps/", "\1", ".blk")

        SECTION FRAGMENT "\1 Header", ROMX, BANK[CUR_BANK]
            dw \1Objects
    POPS
ENDM

UpdateMapObjectCount: MACRO
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
        db {MAP_NAME}TextCount | \2
    ELSE
        db {MAP_NAME}TextCount
    ENDC
ENDM

MapCoord: MACRO
	db \2 + 4
	db \1 + 4
ENDM

MapObjects_NPC: MACRO
    UpdateMapObjectCount Sprite

	db \1
	MapCoord \2, \3
	db \4
	db \5
    
    IF _NARG == 6
        AddTextPointer \6
    ELSE
        SetContext MapObjectsText
    ENDC
ENDM

; todo - need to distinguish between pokemon and trainer
MapObjects_Battle: MACRO
    UpdateMapObjectCount Sprite

    DEF MAP_BATTLE_INDEX = {MAP_NAME}BattleCount
    REDEF POINTER_NAME EQUS "{MAP_NAME}TrainerHeader{d:MAP_BATTLE_INDEX}"

	db \1
	MapCoord \2, \3
	db \4
	db \5

    AddTextPointer {POINTER_NAME}, MapTextTypeTrainer
    
    InitializeBattle \7
    
	db \7
	db {BATTLE_PARTY_INDEX} | ObjectDataTrainerBitMask

    PushContext MapObjectsBattle
    SECTION FRAGMENT "{MAP_NAME} Trainer Headers", ROMX, BANK[CUR_BANK]
        {POINTER_NAME}:
            db 1 << (TotalTrainerBattleCount % 8) ; the mask for this trainer
            db (\6 << 4) | {MAP_NAME}SpriteCount; trainer's view range and sprite index
            dw wTrainerBattleFlags + (TotalTrainerBattleCount / 8)
    
    DEF {MAP_NAME}BattleCount = {MAP_NAME}BattleCount + 1
    DEF TotalTrainerBattleCount = TotalTrainerBattleCount + 1

    DEF OBJ_TEXT_COUNT = 0
ENDM

MapObjects_Pickup: MACRO
    UpdateMapObjectCount Sprite

	db SPRITE_BALL
	MapCoord \1, \2
	db STAY
	db NONE

    db MapTextTypeItem
    
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
MapObjects_Sign: MACRO
    UpdateMapObjectCount Sign

    db \2
    db \1
    IF _NARG == 3
        AddTextPointer \3
    ELSE
        SetContext MapObjectsText
    ENDC
ENDM

;\1 x position
;\2 y position
;\3 destination warp id
;\4 destination map (-1 = wLastMap)
MapObjects_Warp: MACRO
    UpdateMapObjectCount Warp

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
MapObjects_WarpTo: MACRO
    UpdateMapObjectCount WarpTo, 0
    
	EVENT_DISP {MAP_NAME}Width, \2, \1
ENDM

MapObjectsText_text: MACRO
    REDEF POINTER_NAME EQUS "{MAP_NAME}Text{d:{MAP_NAME}TextCount}"

    ; Place the Pointer to the table
    AddTextPointer {POINTER_NAME}

    InitTextContext done, Sign, NPC, Battle, Pickup, WarpTo
    SECTION FRAGMENT "{MAP_NAME} Texts", ROMX, BANK[CUR_BANK]
        {POINTER_NAME}:
            ForwardTo Default_text
ENDM

; Close the map objects text context
MapObjectsText_Text_Finish: MACRO
    CloseContext
ENDM

MapObjectsBattle_text: MACRO
    REDEF POINTER_NAME EQUS "{MAP_NAME}Trainer{d:MAP_BATTLE_INDEX}Text{d:OBJ_TEXT_COUNT}"
    
    SECTION FRAGMENT "{MAP_NAME} Trainer Headers", ROMX, BANK[CUR_BANK]
        dw {POINTER_NAME}

    DEF OBJ_TEXT_COUNT = OBJ_TEXT_COUNT + 1

    IF OBJ_TEXT_COUNT <= 2
        InitTextContext done, text, Team
    ELSE
        InitTextContext prompt, text, Team
    ENDC
    SECTION FRAGMENT "{MAP_NAME} Texts", ROMX, BANK[CUR_BANK]
        {POINTER_NAME}:
            ForwardTo Default_text
ENDM

MapObjectsBattle_Team: MACRO
	SECTION FRAGMENT "{BATTLE_TRAINER_NAME} Party Pointers", ROMX, BANK[TrainerClass]
    ForwardTo InitializeTeam
ENDM

; Close the map objects battle context
MapObjectsBattle_Team_Finish: MACRO
    CloseContext ; close the map objects battle context
ENDM

MapObjects_MapObjectsBattle_Finish: MACRO
    ; If the only three text entries, then duplicate the last one
    ; (Trainer Header Win Text)
    ; TODO - instead, point to a text that will randomly display a relevant message
    IF OBJ_TEXT_COUNT == 3
        SECTION FRAGMENT "{MAP_NAME} Trainer Headers", ROMX, BANK[CUR_BANK]
            dw {POINTER_NAME}
    ENDC
ENDM