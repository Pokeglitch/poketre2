Scope MapScript, Script
    method init
      args , map
        super {map}
        
        MapSec frag, {map} Script
            include strcat("scripts/",strlwr("\2"),".asm")

        end ; this will end ExpectText, which will cascade into ending this Script
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

    method set_script
      args , name
        ld a, {\1#ID}#Scripts#{name}
        ld [w{\1#ID}CurScript], a
    endm
end
