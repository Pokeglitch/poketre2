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
