Route19Object:
	db $43 ; border block

	db 0 ; warps

	db 1 ; signs
	sign 11, 9, 11 ; Route19Text11

	db 10 ; objects
	object SPRITE_BLACK_HAIR_BOY_1, 8, 7, STAY, LEFT, 1, Swimmer, 2
	object SPRITE_BLACK_HAIR_BOY_1, 13, 7, STAY, LEFT, 2, Swimmer, 3
	object SPRITE_SWIMMER, 13, 25, STAY, LEFT, 3, Swimmer, 4
	object SPRITE_SWIMMER, 4, 27, STAY, RIGHT, 4, Swimmer, 5
	object SPRITE_SWIMMER, 16, 31, STAY, UP, 5, Swimmer, 6
	object SPRITE_SWIMMER, 9, 11, STAY, DOWN, 6, Swimmer, 7
	object SPRITE_SWIMMER, 8, 43, STAY, LEFT, 7, Beauty, 12
	object SPRITE_SWIMMER, 11, 43, STAY, RIGHT, 8, Beauty, 13
	object SPRITE_SWIMMER, 9, 42, STAY, UP, 9, Swimmer, 8
	object SPRITE_SWIMMER, 10, 44, STAY, DOWN, 10, Beauty, 14

	; warp-to
