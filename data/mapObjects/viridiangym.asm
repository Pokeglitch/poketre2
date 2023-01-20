ViridianGymObject:
	db $3 ; border block

	db 2 ; warps
	warp 16, 17, 4, -1
	warp 17, 17, 4, -1

	db 0 ; signs

	db 11 ; objects
	object SPRITE_GIOVANNI, 2, 1, STAY, DOWN, 1, Giovanni, 3
	object SPRITE_BLACK_HAIR_BOY_1, 12, 7, STAY, DOWN, 2, CooltrainerM, 9
	object SPRITE_HIKER, 11, 11, STAY, UP, 3, Blackbelt, 6
	object SPRITE_ROCKER, 10, 7, STAY, DOWN, 4, Tamer, 3
	object SPRITE_HIKER, 3, 7, STAY, LEFT, 5, Blackbelt, 7
	object SPRITE_BLACK_HAIR_BOY_1, 13, 5, STAY, RIGHT, 6, CooltrainerM, 10
	object SPRITE_HIKER, 10, 1, STAY, DOWN, 7, Blackbelt, 8
	object SPRITE_ROCKER, 2, 16, STAY, RIGHT, 8, Tamer, 4
	object SPRITE_BLACK_HAIR_BOY_1, 6, 5, STAY, DOWN, 9, CooltrainerM, 1
	object SPRITE_GYM_HELPER, 16, 15, STAY, DOWN, 10 ; person
	object SPRITE_BALL, 16, 9, STAY, NONE, 11, REVIVE

	; warp-to
	warp_to 16, 17, VIRIDIAN_GYM_WIDTH
	warp_to 17, 17, VIRIDIAN_GYM_WIDTH
