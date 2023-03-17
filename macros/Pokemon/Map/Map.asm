Class2 MapDefinition
    property Number, TextCount
    property Number, BattleCount

    method init
      args #Name, #Height, #Width, #Tileset, #Border
        def \1#Bank = BANK(@)

        pushs

        MapSec frag, \1 Header
            \1Header:
                db \1#Tileset, \1#Height, \1#Width
                dw \1Blocks, \1TextPointers, \1Script, \1TrainerHeaders
                db \1#ConnectionFlags

            ; define after allocating so it uses final value
            def \1#ConnectionFlags = 0

        MapScript \1

        MapObjects \1#Objects, \1

        ; after connections are defined, add the objects pointer
        ; TODO - the connections shoud come after the objects pointer, so they can be added after...
        MapSec frag, \1 Header
            dw \1Objects
            
        MapSec \1 Blocks
          \1Blocks:
              incbin "maps/\1.blk"

        end
    endm

    method nextBattleCount
      args
        return \1#BattleCount
        \1#BattleCount@inc
    endm

    method getMap
      args
        return \1
    endm

    ; Open a section in the same bank as this Map
    method MapSec
      args
        def \@#Bank = \1#Bank
        shift
        sec \#, \@#Bank
    endm
    
/*  \1 - X movement (X-blocks)
    \2 = Rows above (Y-blocks)    */
    method EventDisp
      args , x, y
        EVENT_DISP \1#Width, y, x
    endm

    method exit
      args
        pops
    endm
end
