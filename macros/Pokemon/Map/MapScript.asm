Scope MapScript, Script
    method init
      args , map
        super {map}
        
        MapSec frag, {map} Script
            include "scripts/\2.asm"

        end
    endm

    from Text
      args
        super
        DisplayText \2#ID
    endm

    method Battle, "MapScriptBattle"

    method pre
      args
        {\1#ID}PreScript:
    endm

    method post
      args
        {\1#ID}PostScript:
    endm

    method script
      args , name
        AddMapScriptPointer name
    endm

    ; todo - have it be a name, and have Scripts be an enum
    method set_script
      args , index
        ld a, index
        ld [w{\1#ID}CurScript], a
    endm
end
