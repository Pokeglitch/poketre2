Route14Object:
	db $43 ; border block

	db 0 ; warps

	db 1 ; signs
	sign 17, 13, 11 ; Route14Text11

	db 10 ; objects
	object SPRITE_BLACK_HAIR_BOY_1, 4, 4, STAY, DOWN, 1, BirdKeeper, 14
	object SPRITE_BLACK_HAIR_BOY_1, 15, 6, STAY, DOWN, 2, BirdKeeper, 15
	object SPRITE_BLACK_HAIR_BOY_1, 12, 11, STAY, DOWN, 3, BirdKeeper, 16
	object SPRITE_BLACK_HAIR_BOY_1, 14, 15, STAY, UP, 4, BirdKeeper, 17
	object SPRITE_BLACK_HAIR_BOY_1, 15, 31, STAY, LEFT, 5, BirdKeeper, 4
	object SPRITE_BLACK_HAIR_BOY_1, 6, 49, STAY, UP, 6, BirdKeeper, 5
	object SPRITE_BIKER, 5, 39, STAY, DOWN, 7, Biker, 13
	object SPRITE_BIKER, 4, 30, STAY, RIGHT, 8, Biker, 14
	object SPRITE_BIKER, 15, 30, STAY, LEFT, 9, Biker, 15
	object SPRITE_BIKER, 4, 31, STAY, RIGHT, 10, Biker, 2
