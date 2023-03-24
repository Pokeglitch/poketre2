/*
TODO - Give all signs a specific textbox style?
-- option for number of rows
*/

List MapObjects#Order, Warp, Sign, Sprite, WarpTo

Class2 MapObjects
    property Number, CurrentSectionIndex
    forward MapSec, EventDisp
    
    method init
      args , #Map
        def \1#Isolate = true
        def \1#CurrentSectionName equs "{MapObjects#Order#{d:\1#CurrentSectionIndex}}"

        ; Initialize the Section
        TrainerHeadersSec
            \2TrainerHeaders:

        TextsSec
            \2Texts:

        TextPointersSec
            \2TextPointers:

        ObjectsSec
            \2Objects:
                db \2#Border
                include "data/mapObjects/\2.asm"

        ; fill in any empty sections
        InitializeSections MapObjects#Order#_size-1

        ; terminate the trainer headers list
        TrainerHeadersSec
	        db TrainerHeaderTerminator
        end
    endm

    ; call MapSec as attribute of Map since this will get called from other maps as warp-tos
    method ObjectsSec
      args
        {\1#Map}@MapSec frag, {\1#Map} Objects
    endm

    method TrainerHeadersSec
      args
        MapSec frag, {\1#Map} Trainer Headers
    endm

    method TextsSec
      args
        MapSec frag, {\1#Map} Texts
    endm

    method TextPointersSec
      args
        MapSec frag, {\1#Map} Text Pointers
    endm
    
    method InitTrainerHeader
      args , range, pointer
        pushs
        ; Initialize the trainer header
        TrainerHeadersSec
            {pointer}:
                db 1 << (TotalTrainerBattleCount % 8)   ; the mask for this trainer
                db (range << 4) | {\1#Map}#Sprite#Count      ; trainer's view range and sprite index
                dw wTrainerBattleFlags + (TotalTrainerBattleCount / 8)

        def TotalTrainerBattleCount += 1
    endm

    method AddTextPointerOrInitText
      args , text_ptr
        if def(text_ptr)
            AddTextPointer text_ptr
        else
            def \@#name equs "{\1#Map}#{\1#CurrentSectionName}#{d:{\1#Map}#{\1#CurrentSectionName}#Count}#Text"

            pushs
            TextsSec
                {\@#name}:
                
            ; TODO - will this put a 'done' after textasm??
            Text done, Sign, NPC, Battle, Pickup, WarpTo
            SetID {\@#name}
        endc
    endm

    from Text
      args
        pops
        AddTextPointer {\2#ID}
    endm

    method MapCoord
      args , x, y
        db y + 4
        db x + 4
    endm

    method AddTextPointer
      args , text_ptr, flag=0
        pushs
            TextPointersSec
                dw text_ptr
        pops
        
        {\1#Map}#TextCount@inc
        db {\1#Map}#TextCount | flag
    endm
    
    method AddTrainerHeaderPointer
      args , ptr
        TrainerHeadersSec
            dw ptr
    endm

    method UpdateCount
      args
        var \@#index = MapObjects#Order@index(\2)

        if \@#index < \1#CurrentSectionIndex
            fail "Must define \2s before {\1#CurrentSectionName}s"
        endc

        def \1#CurrentSectionIndex = \@#index
        redef \1#CurrentSectionName equs "\2"

        InitializeSections \@#index
        {\1#Map}#\2#Count@inc
    endm

    ; initialize any of the sections from \2 earlier if not already
    ; TODO - can be more efficient up by starting with CurrentSectionIndex ??
    method InitializeSections
      args
        for i, \2+1
            def \@#name equs "{MapObjects#Order#{d:i}}"
            ; if the section is not defined, initialize
            if not def({\1#Map}#{\@#name}#Count)
                
                ; final section (WarpTos) does not begin with a count
                if i < MapObjects#Order#_size-1
                    db {\1#Map}#{\@#name}#Count ; write before defining to use final value
                endc

                ; initialize
                Number {\1#Map}#{\@#name}#Count
            endc
        endr
    endm

    method Sign
      args , x, y, text_ptr
        UpdateCount Sign
        db y, x
        AddTextPointerOrInitText text_ptr
    endm

    method NPC
      args , sprite, x, y, movement, direction, text_ptr
        UpdateCount Sprite
        db sprite
        MapCoord x, y
        db movement, direction
        AddTextPointerOrInitText text_ptr
    endm

    method Battle
      args
        UpdateCount Sprite
        shift
        MapObjectsBattle \#
    endm

    method Pickup
      args , x, y, item, quantity=1
        UpdateCount Sprite
        db SPRITE_BALL
        MapCoord x, y
        db STAY, NONE, MapText#Type#Item, item
        db quantity
    endm

    method Warp
      args , x, y, index, map=-1
        UpdateCount Warp
        db y, x, index, map
    endm

    method WarpTo
      args , x, y
        UpdateCount WarpTo
        EventDisp x, y
    endm
end

; TODO - distinguish between a pokemon and a trainer  
Scope MapObjectsBattle, TrainerBattle
    property List, Texts

    method init
      args , sprite, x, y, movement, direction, range, trainer
        var \1#MapBattleIndex = nextBattleCount()
        vars \1#Trainer = Symbolize({trainer})

        db sprite
        MapCoord x, y
        db movement, direction

        AddTextPointer \@#TrainerHeader, MapText#Type#Trainer

        db \1#Trainer
        ; todo - should be a return value from the Trainer Class
        db {\1#Trainer}PartyCount | ObjectData#Trainer#BitMask
        def {\1#Trainer}PartyCount += 1

        InitTrainerHeader range, \@#TrainerHeader
        ; todo - open text context immediately?
    endm

    ; todo - clean up and use better pointer names
    method text
      args
        if \1#Texts#_size == 4
            fail "Already defined 4 Battle Texts"
        endc

        \1#Texts@push \@#Text
        AddTrainerHeaderPointer \@#Text

        ; First two texts finish with done (in overworld)
        if \1#Texts#_size <= 2
            Text done, Team
        ; Last two texts finish with prompt (in battle)
        else
            Text prompt, Team
        endc

        pushs
        TextsSec
            \@#Text:
                shift
                text \#
    endm

    ; TODO - can use generic Win or Loss texts if not provided
    method exit
      args
        ; todo - also if missing before or after
        if \1#Texts#_size < 3
            fail "Battle Win/Lose Texts are missing"
        ; If Lose Text is missing, then duplicate the last text (the win text)
        elif \1#Texts#_size == 3
            AddTrainerHeaderPointer {\1#Texts#2}
        endc

        pops
    endm
end
