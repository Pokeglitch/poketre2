; Loads tile patterns for tiles used in the pokedex.
LoadPokedexTilePatterns:
	ld de, PokedexTileGFX
	ld hl, vChars1 + $400
	lb bc, BANK(PokedexTileGFX), (PokedexTileGFXEnd - PokedexTileGFX) / BYTES_PER_TILE
	call CopyVideoData

	ld de, PokedexSymbolsGFX
	ld hl, vChars1 + $600
	lb bc, BANK(PokedexSymbolsGFX), (PokedexSymbolsGFXEnd - PokedexSymbolsGFX) / BYTES_PER_TILE
	jp CopyVideoData