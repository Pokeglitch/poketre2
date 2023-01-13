PokemonCount = 0
Pokemon: MACRO
    DEF PokemonCount += 1
ENDM

OtherCount = 0
Other: MACRO
    DEF OtherCount += 1
ENDM

INCLUDE "classes/pokemon.asm"
INCLUDE "classes/other.asm"
