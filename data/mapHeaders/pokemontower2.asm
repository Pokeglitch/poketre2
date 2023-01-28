PokemonTower2_h:
	db CEMETERY ; tileset
	db POKEMONTOWER_2_HEIGHT, POKEMONTOWER_2_WIDTH ; dimensions (y, x)
	dw PokemonTower2Blocks, PokemonTower2TextPointers, PokemonTower2Script, PokemonTower2TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw PokemonTower2Object ; objects
