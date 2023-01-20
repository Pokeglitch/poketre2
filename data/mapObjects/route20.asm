Route20Object:
	db $43 ; border block

	db 2 ; warps
	warp 48, 5, 0, SEAFOAM_ISLANDS_1
	warp 58, 9, 2, SEAFOAM_ISLANDS_1

	db 2 ; signs
	sign 51, 7, 11 ; Route20Text11
	sign 57, 11, 12 ; Route20Text12

	db 10 ; objects
	object SPRITE_SWIMMER, 87, 8, STAY, UP, 1, Swimmer, 9
	object SPRITE_SWIMMER, 68, 11, STAY, UP, 2, Beauty, 15
	object SPRITE_SWIMMER, 45, 10, STAY, DOWN, 3, Beauty, 6
	object SPRITE_SWIMMER, 55, 14, STAY, RIGHT, 4, JrTrainerF, 24
	object SPRITE_SWIMMER, 38, 13, STAY, DOWN, 5, Swimmer, 10
	object SPRITE_SWIMMER, 87, 13, STAY, UP, 6, Swimmer, 11
	object SPRITE_BLACK_HAIR_BOY_1, 34, 9, STAY, UP, 7, BirdKeeper, 11
	object SPRITE_SWIMMER, 25, 7, STAY, UP, 8, Beauty, 7
	object SPRITE_SWIMMER, 24, 12, STAY, DOWN, 9, JrTrainerF, 16
	object SPRITE_SWIMMER, 15, 8, STAY, UP, 10, Beauty, 8

	; warp-to
	warp_to 48, 5, ROUTE_20_WIDTH ; SEAFOAM_ISLANDS_1
	warp_to 58, 9, ROUTE_20_WIDTH ; SEAFOAM_ISLANDS_1
