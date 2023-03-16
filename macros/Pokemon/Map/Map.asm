Class2 MapDefinition
    property Number, TextCount
    property Number, BattleCount

    method init
      args #Name, #Height, #Width, #Tileset, #Border
        def \1#Bank = BANK(@)

        pushs
        MapScript \1
    endm

    method nextBattleCount
      args
        return \1#BattleCount
        \1#BattleCount@inc
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
