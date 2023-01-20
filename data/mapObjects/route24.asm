Route24Object:
	db $2c ; border block

	db 0 ; warps

	db 0 ; signs

	db 8 ; objects
	object SPRITE_BLACK_HAIR_BOY_1, 11, 15, STAY, LEFT, 1, Rocket, 6
	object SPRITE_BLACK_HAIR_BOY_1, 5, 20, STAY, UP, 2, JrTrainerM, 2
	object SPRITE_BLACK_HAIR_BOY_1, 11, 19, STAY, LEFT, 3, JrTrainerM, 3
	object SPRITE_LASS, 10, 22, STAY, RIGHT, 4, Lass, 7
	object SPRITE_BUG_CATCHER, 11, 25, STAY, LEFT, 5, Youngster, 4
	object SPRITE_LASS, 10, 28, STAY, RIGHT, 6, Lass, 8
	object SPRITE_BUG_CATCHER, 11, 31, STAY, LEFT, 7, BugCatcher, 9
	object SPRITE_BALL, 10, 5, STAY, NONE, 8, TM_45
