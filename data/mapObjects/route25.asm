Route25Object:
	db $2c ; border block

	db 1 ; warps
	warp 45, 3, 0, BILLS_HOUSE

	db 1 ; signs
	sign 43, 3, 11 ; Route25Text11

	db 10 ; objects
	object SPRITE_BUG_CATCHER, 14, 2, STAY, DOWN, 1, Youngster, 5
	object SPRITE_BUG_CATCHER, 18, 5, STAY, UP, 2, Youngster, 6
	object SPRITE_BLACK_HAIR_BOY_1, 24, 4, STAY, DOWN, 3, JrTrainerM, 2
	object SPRITE_LASS, 18, 8, STAY, RIGHT, 4, Lass, 9
	object SPRITE_BUG_CATCHER, 32, 3, STAY, LEFT, 5, Youngster, 7
	object SPRITE_LASS, 37, 4, STAY, DOWN, 6, Lass, 10
	object SPRITE_HIKER, 8, 4, STAY, RIGHT, 7, Hiker, 2
	object SPRITE_HIKER, 23, 9, STAY, UP, 8, Hiker, 3
	object SPRITE_HIKER, 13, 7, STAY, RIGHT, 9, Hiker, 4
	object SPRITE_BALL, 22, 2, STAY, NONE, 10, TM_19

	; warp-to
	warp_to 45, 3, ROUTE_25_WIDTH ; BILLS_HOUSE
