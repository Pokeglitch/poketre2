Route9Object:
	db $2c ; border block

	db 0 ; warps

	db 1 ; signs
	sign 25, 7, 11 ; Route9Text11

	db 10 ; objects
	object SPRITE_LASS, 13, 10, STAY, LEFT, 1, JrTrainerF, 5
	object SPRITE_BLACK_HAIR_BOY_1, 24, 7, STAY, LEFT, 2, JrTrainerM, 7
	object SPRITE_BLACK_HAIR_BOY_1, 31, 7, STAY, RIGHT, 3, JrTrainerM, 8
	object SPRITE_LASS, 48, 8, STAY, RIGHT, 4, JrTrainerF, 6
	object SPRITE_HIKER, 16, 15, STAY, LEFT, 5, Hiker, 11
	object SPRITE_HIKER, 43, 3, STAY, LEFT, 6, Hiker, 6
	object SPRITE_BUG_CATCHER, 22, 2, STAY, DOWN, 7, BugCatcher, 13
	object SPRITE_HIKER, 45, 15, STAY, RIGHT, 8, Hiker, 5
	object SPRITE_BUG_CATCHER, 40, 8, STAY, RIGHT, 9, BugCatcher, 14
	object SPRITE_BALL, 10, 15, STAY, NONE, 10, TM_30
