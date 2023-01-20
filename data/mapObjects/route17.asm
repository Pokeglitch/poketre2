Route17Object:
	db $43 ; border block

	db 0 ; warps

	db 6 ; signs
	sign 9, 51, 11 ; Route17Text11
	sign 9, 63, 12 ; Route17Text12
	sign 9, 75, 13 ; Route17Text13
	sign 9, 87, 14 ; Route17Text14
	sign 9, 111, 15 ; Route17Text15
	sign 9, 141, 16 ; Route17Text16

	db 10 ; objects
	object SPRITE_BIKER, 12, 19, STAY, LEFT, 1, CueBall, 4
	object SPRITE_BIKER, 11, 16, STAY, RIGHT, 2, CueBall, 5
	object SPRITE_BIKER, 4, 18, STAY, UP, 3, Biker, 8
	object SPRITE_BIKER, 7, 32, STAY, LEFT, 4, Biker, 9
	object SPRITE_BIKER, 14, 34, STAY, RIGHT, 5, Biker, 10
	object SPRITE_BIKER, 17, 58, STAY, LEFT, 6, CueBall, 6
	object SPRITE_BIKER, 2, 68, STAY, RIGHT, 7, CueBall, 7
	object SPRITE_BIKER, 14, 98, STAY, RIGHT, 8, CueBall, 8
	object SPRITE_BIKER, 5, 98, STAY, LEFT, 9, Biker, 11
	object SPRITE_BIKER, 10, 118, STAY, DOWN, 10, Biker, 12
