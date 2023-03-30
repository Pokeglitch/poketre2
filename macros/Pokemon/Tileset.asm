Number Tileset#Count

Class2 Tileset
    method init
      args , #Bank, #Border, Permission=INDOOR, GrassTile=-1, CounterTile1=-1, CounterTile2=-1, CounterTile3=-1
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
        db CounterTile1, CounterTile2, CounterTile3
        db GrassTile, Permission
    endm
end
