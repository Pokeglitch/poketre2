Class2 MapDefinition
    property Number, TextCount
    property Number, BattleCount

    method init
      args #Name, #Height, #Width, #Tileset, #Border
        def \1#Bank = BANK(@)

        pushs
        MapScript \1
    endm

    ; Open a section in the same bank as this Map
    method MapSec
      args
        def \@#Bank = \1#Bank
        shift
        sec \#, \@#Bank
    endm

    method exit
      args
        pops
    endm
end
