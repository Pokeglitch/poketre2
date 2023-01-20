MtMoon1Object:
	db $3 ; border block

	db 5 ; warps
	warp 14, 35, 1, -1
	warp 15, 35, 1, -1
	warp 5, 5, 0, MT_MOON_2
	warp 17, 11, 2, MT_MOON_2
	warp 25, 15, 3, MT_MOON_2

	db 1 ; signs
	sign 15, 23, 14 ; MtMoon1Text14

	db 13 ; objects
	object SPRITE_HIKER, 5, 6, STAY, DOWN, 1, Hiker, 1
	object SPRITE_BUG_CATCHER, 12, 16, STAY, RIGHT, 2, Youngster, 3
	object SPRITE_LASS, 30, 4, STAY, DOWN, 3, Lass, 5
	object SPRITE_BLACK_HAIR_BOY_2, 24, 31, STAY, UP, 4, SuperNerd, 1
	object SPRITE_LASS, 16, 23, STAY, DOWN, 5, Lass, 6
	object SPRITE_BUG_CATCHER, 7, 22, STAY, DOWN, 6, BugCatcher, 7
	object SPRITE_BUG_CATCHER, 30, 27, STAY, RIGHT, 7, BugCatcher, 8
	object SPRITE_BALL, 2, 20, STAY, NONE, 8, POTION
	object SPRITE_BALL, 2, 2, STAY, NONE, 9, MOON_STONE
	object SPRITE_BALL, 35, 31, STAY, NONE, 10, RARE_CANDY
	object SPRITE_BALL, 36, 23, STAY, NONE, 11, ESCAPE_ROPE
	object SPRITE_BALL, 20, 33, STAY, NONE, 12, POTION
	object SPRITE_BALL, 5, 32, STAY, NONE, 13, TM_12

	; warp-to
	warp_to 14, 35, MT_MOON_1_WIDTH
	warp_to 15, 35, MT_MOON_1_WIDTH
	warp_to 5, 5, MT_MOON_1_WIDTH ; MT_MOON_2
	warp_to 17, 11, MT_MOON_1_WIDTH ; MT_MOON_2
	warp_to 25, 15, MT_MOON_1_WIDTH ; MT_MOON_2
