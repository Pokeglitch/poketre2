PokemonTower7_h:
	db CEMETERY ; tileset
	db POKEMONTOWER_7_HEIGHT, POKEMONTOWER_7_WIDTH ; dimensions (y, x)
	dw PokemonTower7Blocks, PokemonTower7TextPointers, PokemonTower7Script, PokemonTower7TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw PokemonTower7Object ; objects
