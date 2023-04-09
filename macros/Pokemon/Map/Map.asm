Class MapDefinition
    property Number, TextCount
    property Number, BattleCount
    property Enum, Scripts

    method init
      args #Name, #Height, #Width, #Tileset, #Border
        def \1#Bank = BANK(@)
        def \1#ConnectionFlags = 0

        ; Use the tileset's default border if not provided
        if not def(\1#Border)
            def \1#Border = {\1#Tileset}#Border
        endc

        pushs

        MapScript \1

        MapObjects \1#Objects, \1
            
        MapSec \1 Blocks
            \1Blocks:
                incbin "maps/\1.blk"

        ; todo - isntead, place in generic map table, along with Bank
        MapSec frag, \1 Header
            \1Header:
                db {\1#Tileset}#ID, \1#Height, \1#Width
                dw \1Blocks, \1TextPointers, \1Script, \1TrainerHeaders
                db \1#ConnectionFlags

        ; after connections are defined, add the objects pointer
        ; TODO - the connections shoud come after the objects pointer, so they can be added after...
        MapSec frag, \1 Header
            dw \1Objects
        end
    endm

    from MapScript
      args
        if not def(\1Script)
            \1Script:
                if def(\1PreScript)
                    call \1PreScript
                endc
                if \1#Scripts#_size
                    ld hl, \1ScriptPointers
                    ld a, [w\1CurScript]
                    call RunIndexedMapScript
                endc
                if def(\1PostScript)
                    call \1PostScript
                endc
                ret
        endc
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

    method MainScriptSec
      args
        MapSec frag, \1 Main Script
    endm

    method AddMapScriptPointer
      args , name
        pushs
        MapSec frag, \1 Script Pointers
            if not \1#Scripts#_size
                \1ScriptPointers:
            endc
            
            dw \1#Scripts#{name}#Pointer
        pops

        \1#Scripts@push {name}

        \1#Scripts#{name}#Pointer:
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
