; Loads tile patterns for tiles used in the pokedex.
LoadPokedexTilePatterns:
	call LoadBlackOnLightFontTilePatterns
	;call LoadHpBarAndStatusTilePatterns
	
	ld de, PokedexTileGraphics1
	ld hl, vChars1 + $400
	lb bc, BANK(PokedexTileGraphics1), (PokedexTileGraphics1End - PokedexTileGraphics1) / $10
	call CopyVideoData
	
	; TODO
	; Dont overwrite the tileset, use the bottom 2 rows of sprites
	; to draw only what is necessary for the base dex
	ld de, PokedexTileGraphics2
	ld hl, vChars2 + $600
	lb bc, BANK(PokedexTileGraphics2), (PokedexTileGraphics2End - PokedexTileGraphics2) / $10
	jp CopyVideoData

	;ld de, PokeballTileGraphics
	;ld hl, vChars2 + $720
	;lb bc, BANK(PokeballTileGraphics), $01
	;jp CopyVideoData ; load pokeball tile for marking caught mons
