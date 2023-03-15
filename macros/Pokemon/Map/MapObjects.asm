/*
TODO:
    - fail if macro other than text is called when text is expected
        - or, if trying to define section with index lower than current section
*/
List MapObjects#Order, Warp, Sign, Sprite, WarpTo

Scope MapObjects
    property Number, CurrentSection
    forward MapSec, EventDisp
    
    method init
      args , #Map
        def \1#Isolate = true
        def \1#ExpectText = false
        def \2#Objects equs "\1"

        ObjSec
            \2#Objects:
                db \2#Border
                include "data/mapObjects/\2.asm"

        ; fill in any empty sections
        InitializeSections MapObjects#Order#_size-1

        end
    endm

    method ObjSec
      args
        ; call as attribute of Map since this gets called from other maps
        {\1#Map}@MapSec frag, {\1#Map} Objects
    endm

    method text
      args
        if \1#ExpectText
            def \1#ExpectText = false
            Text done, Sign, NPC, Battle, Pickup, WarpTo
            shift
            more \#
        else
            fail "text is not permitted here"
        endc
    endm

    from Text
      args
        pops
    endm

    method MapCoord
      args , X, Y
        db Y + 4
        db X + 4
    endm

    method AddTextPointerOrInitText
      args , text_ptr
        if def(text_ptr)
            AddTextPointer text_ptr
        else
            InitText
        endc
    endm

    method AddTextPointer
      args
        pushs
            MapSec frag, {\1#Map} Text Pointers
                dw \2
        pops
        
        {\1#Map}#TextCount@inc

        ; If a flag was provided, then write it
        if _narg == 3
            db {\1#Map}#TextCount | \3
        else
            db {\1#Map}#TextCount
        endc
    endm

    method UpdateCount
      args
        ; if a text is expected, then fail
        if \1#ExpectText
            fail "Expected text, Received \2"
        endc
        
        var \@#index = MapObjects#Order@index(\2)

        if \@#index < \1#CurrentSection
            fail "Cannot place a \2 after a {MapObjects#Order#{d:\1#CurrentSection}}"
        endc

        def \1#CurrentSection = \@#index

        InitializeSections \@#index
        {\1#Map}#\2#Count@inc
    endm

    ; initialize any of the sections from \2 earlier if not already
    method InitializeSections
      args
        for i, \2+1
            def \@#name equs "{MapObjects#Order#{d:i}}"
            ; if the section is not defined, initialize
            if not def({\1#Map}#{\@#name}#Count)
                
                ; final section does not begin with a count
                if i < MapObjects#Order#_size-1
                    db {\1#Map}#{\@#name}#Count ; write before defining to use final value
                endc

                ; initialize
                Number {\1#Map}#{\@#name}#Count
            endc
        endr
    endm

    method InitText
      args
        AddTextPointer \@#Text

        pushs
        MapSec frag, {\1#Map} Texts
            \@#Text:
            
        def \1#ExpectText = true
    endm

    method Sign
      args , x, y, text_ptr
        UpdateCount Sign
        db y, x
        AddTextPointerOrInitText text_ptr
    endm

    method NPC
      args , sprite, x, y, movement, range, text_ptr
        UpdateCount Sprite
        db sprite
        MapCoord x, y
        db movement, range
        AddTextPointerOrInitText text_ptr
    endm

    method Battle
      args
        UpdateCount Sprite
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
      args , x, y, index, map = -1
        UpdateCount Warp
        db y, x, index, map
    endm

    method WarpTo
      args , x, y
        UpdateCount WarpTo
        EventDisp x, y
    endm
end

; TODO - extend a generic 'TrainerBattle' scope
;      - need to distinguish between pokemon and trainer  
Scope MapObjectsBattle
    property List, Texts

    method init
      args
        def \1#Map equs "{\2#Map}"
        def \1#MapBattleIndex = {\1#Map}#BattleCount
        {\1#Map}#BattleCount@inc
        vars \1#Trainer = Symbolize(\9)

        db \3
        MapCoord \4, \5
        db \6
        db \7

        AddTextPointer \@#TrainerHeader, MapText#Type#Trainer

        db \1#Trainer
        db {\1#Trainer}PartyCount | ObjectData#Trainer#BitMask
        def {\1#Trainer}PartyCount += 1

        pushs
        ; Initialize the trainer header
        SecHeader
            \@#TrainerHeader:
                db 1 << (TotalTrainerBattleCount % 8)   ; the mask for this trainer
                db (\8 << 4) | {\1#Map}#Sprite#Count      ; trainer's view range and sprite index
                dw wTrainerBattleFlags + (TotalTrainerBattleCount / 8)
                
        def TotalTrainerBattleCount += 1
    endm

    method SecHeader
      args
        MapSec frag, {\1#Map} Trainer Headers
    endm

    method AddPointer
      args
        SecHeader
            dw \2
    endm

    method text
      args
        if \1#Texts#_size == 4
            fail "Already defined 4 Battle Texts"
        endc

        \1#Texts@push \@#Text
        AddPointer \@#Text

        ; First two texts finish with done (in overworld)
        if \1#Texts#_size <= 2
            Text done, Team
        ; Last two texts finish with prompt (in battle)
        else
            Text prompt, Team
        endc

        pushs
        MapSec frag, {\1#Map} Texts
            \@#Text:
                shift
                more \#
    endm

    from Text
      args
        pops
    endm

    method Team
      args
        section fragment "{\1#Trainer} Party Pointers", romx, bank[TrainerClass]
            shift
            TrainerTeam \#
    endm

    from TrainerTeam, "end"

    ; TODO - can use generic Win or Loss texts if not provided
    method exit
      args
        if \1#Texts#_size < 3
            fail "Battle Win/Lose Texts are missing"
        ; If Lose Text is missing, then duplicate the last text (the win text)
        elif \1#Texts#_size == 3
            AddPointer {\1#Texts#2}
        endc

        pops
    endm
end
