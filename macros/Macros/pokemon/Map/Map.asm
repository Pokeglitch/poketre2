Scope MapDefinition
    init
        Number \2#TextCount
        Number \2#BattleCount

        DEF \2#Height = \3
        DEF \2#Width = \4
        DEF \2#Tileset = \5
        DEF \2#Border = \6
    
        def \1#Map equs "\2"
        def \1#Bank = BANK(@)
        pushs
        
        MapScript \2
    endm

    ; Open a section in the same bank as this Map
    method MapSec
      args
        def \@#Bank = \1#Bank
        shift
        sec \#, \@#Bank
    endm

    exit
        pops
    endm
end
