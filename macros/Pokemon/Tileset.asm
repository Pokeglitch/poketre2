Number Tileset#Count
Enum Tileset#Animations, None, Water, Flower

Class Tileset
    property List, Counters

    method init
      args , #Bank, #Border, #Animations=None, #Grass=-1, Counters
        def \1#ID = Tileset#Count
        Tileset#Count@inc
        
        pushs
        sec frag, Tileset Collisions, 0
            \1_Coll::  INCBIN  strcat("gfx/tilesets/",strlwr("\1"),".tilecoll")

        sec frag, \1 Tileset, \1#Bank
            \1_GFX:     INCBIN strcat("gfx/tilesets/",strlwr("\1"),".2bpp")
            \1_Block:   INCBIN strcat("gfx/blocksets/",strlwr("\1"),".bst")
        pops


        db \1#Bank
        dw \1_Block, \1_GFX, \1_Coll ; Block, GFX, Coll
        assign Counters
        db \1#Grass
        db Tileset#Animations#{\1#Animations}
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
