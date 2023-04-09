List MapObjects#Order, Warp, Sign, Sprite, WarpTo

Class MapObjects
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
            Text {\1#Map}#{\1#CurrentSectionName}#{d:{\1#Map}#{\1#CurrentSectionName}#Count}#Text, done, Sign, NPC, Battle, Pickup, WarpTo
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

        InitializeSections \@#index
        {\1#Map}#\2#Count@inc

        def \1#CurrentSectionIndex = \@#index
        redef \1#CurrentSectionName equs "\2"

    endm

    ; initialize any of the sections from \2 earlier if not already
    method InitializeSections
      args
        for i, \1#CurrentSectionIndex, \2+1
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
      args self
        UpdateCount Sprite
        shift
        MapObjectsBattle {self}#Sprite#{d:{{self}#Map}#Sprite#Count}, \#
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
