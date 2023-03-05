/*
TODO:
    - turn UseSuper off when Definition permits UseSuper within these methods
    - fail if macro other than text is called when text is expected
        - or, if trying to define section with index lower than current section
*/
List MapObjects#Order, Warp, Sign, Sprite, WarpTo

Scope MapObjects
    init
        def \1#Map equs "\2"
        def \1#ExpectText = false

        MapSec frag, \2 Objects
            \2#Objects:
                db \2#Border
                include "data/mapObjects/\2.asm"

        ; fill in any empty sections
        InitializeSections MapObjects#Order#_size-1

        end
    endm

    method text
    func
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
    func
        pops
    endm

/*  \1 - X movement (X-blocks)
    \2 = Rows above (Y-blocks)    */
    method EventDisp
    func
        EVENT_DISP {\1#Map}#Width, \3, \2
    endm

    method MapCoord
    func
        db \3 + 4
        db \2 + 4
    endm

    method AddTextPointer
    func
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
    func
        var \@#index = MapObjects#Order@index(\2)
        InitializeSections \@#index
        {\1#Map}#\2#Count@inc
    endm

    ; initialize any of the sections from \2 earlier if not already
    method InitializeSections
    func
        for i, \2+1
            def \@#name equs "{MapObjects#Order#{d:i}}"
            ; if the section is not defined, initialize
            if not def({\1#Map}#{\@#name}#Count)
                
                ; last section does not begin with a count
                if i < MapObjects#Order#_size-1
                    db {\1#Map}#{\@#name}#Count ; write before defining to use final value
                endc

                ; initialize
                Number {\1#Map}#{\@#name}#Count
            endc
        endr
    endm

    method InitText
    func
        AddTextPointer \@#Text

        pushs
        MapSec frag, {\1#Map} Texts
            \@#Text:
            
        def \1#ExpectText = true
    endm

/*  \1 - x position
    \2 - y position
    \3? - sign id    */
    method Sign
    func
        UpdateCount Sign
        db \3, \2
        ; If a specific pointer was provided, use it. otherwise enter Text context
        if _narg == 4
            AddTextPointer \4
        else
            InitText
        endc
    endm

    method NPC
    func
        UpdateCount Sprite
        db \2
        MapCoord \3, \4
        db \5, \6
        ; If a specific pointer was provided, use it. otherwise enter Text context
        if _narg == 7
            AddTextPointer \7
        else
            InitText
        endc
    endm

    method Battle
    func
        UpdateCount Sprite
        MapObjectsBattle \#
    endm

    method Pickup
    func
        UpdateCount Sprite
        db SPRITE_BALL
        MapCoord \2, \3
        db STAY, NONE, MapText#Type#Item, \4
        ; if a specific amount is provided, use it. otherwise, use 1
        if _narg == 5
            db \5
        else
            db 1
        endc
    endm

/*  \1 - x position
    \2 - y position
    \3 - destination warp id
    \4? - destination map (-1 = wLastMap)    */
    method Warp
    func
        UpdateCount Warp
        db \3, \2, \4
        ; if a specific map is provided, use it. otherwise use previous map
        if _narg == 5
            db \5
        else
            db -1
        endc
    endm

/*  \1 - x position
    \2 - y position    */
    method WarpTo
    func
        UpdateCount WarpTo
        EventDisp \2, \3
    endm
end

; TODO - extend a generic 'TrainerBattle' scope
;      - need to distinguish between pokemon and trainer  
Scope MapObjectsBattle
    property List, Texts

    init
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
    func
        MapSec frag, {\1#Map} Trainer Headers
    endm

    method AddPointer
    func
        SecHeader
            dw \2
    endm

    method text
    func
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
    func
        pops
    endm

    method Team
    func
        section fragment "{\1#Trainer} Party Pointers", romx, bank[TrainerClass]
            shift
            TrainerTeam \#
    endm

    from TrainerTeam, "end"

    ; TODO - can use generic Win or Loss texts if not provided
    exit
        if \1#Texts#_size < 3
            fail "Battle Win/Lose Texts are missing"
        ; If Lose Text is missing, then duplicate the last text (the win text)
        elif \1#Texts#_size == 3
            AddPointer {\1#Texts#2}
        endc

        pops
    endm
end
