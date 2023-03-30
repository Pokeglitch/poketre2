Number Tileset#Count

Class2 Tileset
    property List, Counters

    method init
      args , #Bank, #Border, Permission=INDOOR, GrassTile=-1, Counters
        pushs
        sec frag, Tileset Collisions, 0
            \1_Coll::  INCBIN  "gfx/tilesets/\1.tilecoll"

        sec frag, \1 Tileset, \1#Bank
            \1_GFX:     INCBIN "gfx/tilesets/\1.2bpp"
            \1_Block:   INCBIN "gfx/blocksets/\1.bst"
        pops

        def \1#ID = Tileset#Count
        Tileset#Count@inc


        db \1#Bank
        dw \1_Block, \1_GFX, \1_Coll ; Block, GFX, Coll
        assign Counters
        db GrassTile, Permission
    endm

    method assign
      args
        detuple \2
        assign\2 {\2}
    endm

    method assignCounters
      args self, c1=-1, c2=-1, c3=-1
        shift
        {self}#Counters@push \#
        db c1, c2, c3
    endm
end
