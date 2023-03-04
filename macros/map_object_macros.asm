    ByteStruct MapObject
        Index TextIndex, %01111111
        Flag Sign
    end

    ByteStruct ObjectData
        overload
            Index Level, 100
        next
            Index PartyIndex, %01111111
        end

        Flag Trainer
    end

    ByteStruct MapText
        Index Index, %00011111
        Array Type, 3, Standard, Item, Trainer
    end

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
MACRO MapData
    REDEF MAP_NAME EQUS "\1"
    DEF CUR_BANK = BANK(@)

    MapDefinition \#

        SECTION FRAGMENT "\1 Header", ROMX, BANK[CUR_BANK]
            \1Header:
                db \1#Tileset
                db \1#Height, \1#Width
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

        MapObjects \1

        SECTION FRAGMENT "\1 Trainer Headers", ROMX, BANK[CUR_BANK]
	        db TrainerHeaderTerminator

        SECTION "\1 Blocks", ROMX, BANK[CUR_BANK]
            \1Blocks:
                INCBIN STRCAT("maps/", "\1", ".blk")

        SECTION FRAGMENT "\1 Header", ROMX, BANK[CUR_BANK]
            dw \1#Objects
    end
ENDM
