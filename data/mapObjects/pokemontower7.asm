PokemonTower7Object:
	db $1 ; border block

	db 1 ; warps
	warp 9, 16, 1, POKEMONTOWER_6

	db 0 ; signs

	db 4 ; objects
	object SPRITE_ROCKET, 9, 11, STAY, RIGHT, 1, Rocket, 19
	object SPRITE_ROCKET, 12, 9, STAY, LEFT, 2, Rocket, 20
	object SPRITE_ROCKET, 9, 7, STAY, RIGHT, 3, Rocket, 21
	object SPRITE_MR_FUJI, 10, 3, STAY, DOWN, 4 ; person

	; warp-to
	warp_to 9, 16, POKEMONTOWER_7_WIDTH ; POKEMONTOWER_6
