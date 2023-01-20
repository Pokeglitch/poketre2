RockTunnel2Object:
	db $3 ; border block

	db 4 ; warps
	warp 33, 25, 4, ROCK_TUNNEL_1
	warp 27, 3, 5, ROCK_TUNNEL_1
	warp 23, 11, 6, ROCK_TUNNEL_1
	warp 3, 3, 7, ROCK_TUNNEL_1

	db 0 ; signs

	db 8 ; objects
	object SPRITE_LASS, 11, 13, STAY, DOWN, 1, JrTrainerF, 9
	object SPRITE_HIKER, 6, 10, STAY, DOWN, 2, Hiker, 9
	object SPRITE_BLACK_HAIR_BOY_2, 3, 5, STAY, DOWN, 3, PokeManiac, 3
	object SPRITE_BLACK_HAIR_BOY_2, 20, 21, STAY, RIGHT, 4, PokeManiac, 4
	object SPRITE_HIKER, 30, 10, STAY, DOWN, 5, Hiker, 10
	object SPRITE_LASS, 14, 28, STAY, RIGHT, 6, JrTrainerF, 10
	object SPRITE_HIKER, 33, 5, STAY, RIGHT, 7, Hiker, 11
	object SPRITE_BLACK_HAIR_BOY_2, 26, 30, STAY, DOWN, 8, PokeManiac, 5

	; warp-to
	warp_to 33, 25, ROCK_TUNNEL_2_WIDTH ; ROCK_TUNNEL_1
	warp_to 27, 3, ROCK_TUNNEL_2_WIDTH ; ROCK_TUNNEL_1
	warp_to 23, 11, ROCK_TUNNEL_2_WIDTH ; ROCK_TUNNEL_1
	warp_to 3, 3, ROCK_TUNNEL_2_WIDTH ; ROCK_TUNNEL_1
