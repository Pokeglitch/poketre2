PokemonTower1_h:
	db CEMETERY ; tileset
	db POKEMONTOWER_1_HEIGHT, POKEMONTOWER_1_WIDTH ; dimensions (y, x)
	dw PokemonTower1Blocks, PokemonTower1TextPointers, PokemonTower1Script, PokemonTower1TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw PokemonTower1Object ; objects
