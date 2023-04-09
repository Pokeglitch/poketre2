List BattleTexts, Before, After, Win, Lose

; TODO - distinguish between a pokemon and a trainer  
Class MapObjectsBattle, TrainerBattle
    property List, Texts

    method init
      args , #Sprite, #X, #Y, #Movement, #Direction, #Range, trainer
        var \1#MapBattleIndex = nextBattleCount()
        vars \1#Trainer = Symbolize({trainer})

        db \1#Sprite
        MapCoord \1#X, \1#Y
        db \1#Movement, \1#Direction

        AddTextPointer \1#TrainerHeader, MapText#Type#Trainer

        db \1#Trainer
        ; todo - should be a return value from the Trainer Class
        db {\1#Trainer}PartyCount | ObjectData#Trainer#BitMask
        def {\1#Trainer}PartyCount += 1

        InitTrainerHeader \1#Range, \1#TrainerHeader

        TryExpectBattleText
    endm

    method TryExpectBattleText
      args
        if \1#Texts#_size <= 1
            ExpectBattleText done
        elif \1#Texts#_size <= 3
            ExpectBattleText prompt
        endc
    endm

    method ExpectBattleText
      args , method
        ExpectText true, true, {method}, Team
    endm

    method getTextNameByIndex
      args
        return \1#{BattleTexts#\2}BattleText
    endm

    method getTextName
      args
        return getTextNameByIndex({d:\1#Texts#_size})
    endm

    from Text
      args
        super
        \1#Texts@push {\2#ID}
        AddTrainerHeaderPointer {\2#ID}
        TryExpectBattleText
    endm

    ; TODO - can use generic Win or Loss texts if not provided
    method exit
      args
        def \1#missing equs ""

        for battle_text_i, 3
            vars \@#name = getTextNameByIndex({d:battle_text_i})
            if not def({\@#name})
                append \1#missing, {BattleTexts#{d:battle_text_i}}
            endc
        endr

        if strlen("{\1#missing}")
            fail "\1 is missing Text(s): {\1#missing}"
        endc

        ; If Lose Text is missing, then duplicate the last text (the win text)
        if not def(\1#LoseBattleText)
            AddTrainerHeaderPointer {\1#Texts#2}
        endc

        pops
    endm
end
