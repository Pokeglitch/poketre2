PokemonTower6Object:
	db $1 ; border block

	db 2 ; warps
	warp 18, 9, 1, POKEMONTOWER_5
	warp 9, 16, 0, POKEMONTOWER_7

	db 0 ; signs

	db 5 ; objects
	object SPRITE_MEDIUM, 12, 10, STAY, RIGHT, 1, Channeler, 19
	object SPRITE_MEDIUM, 9, 5, STAY, DOWN, 2, Channeler, 20
	object SPRITE_MEDIUM, 16, 5, STAY, LEFT, 3, Channeler, 21
	object SPRITE_BALL, 6, 8, STAY, NONE, 4, RARE_CANDY
	object SPRITE_BALL, 14, 14, STAY, NONE, 5, X_ACCURACY

	; warp-to
	warp_to 18, 9, POKEMONTOWER_6_WIDTH ; POKEMONTOWER_5
	warp_to 9, 16, POKEMONTOWER_6_WIDTH ; POKEMONTOWER_7
