Route6Object:
	db $f ; border block

	db 4 ; warps
	warp 9, 1, 2, ROUTE_6_GATE
	warp 10, 1, 2, ROUTE_6_GATE
	warp 10, 7, 0, ROUTE_6_GATE
	warp 17, 13, 0, PATH_ENTRANCE_ROUTE_6

	db 1 ; signs
	sign 19, 15, 7 ; Route6Text7

	db 6 ; objects
	object SPRITE_BLACK_HAIR_BOY_1, 10, 21, STAY, RIGHT, 1, JrTrainerM, 4
	object SPRITE_LASS, 11, 21, STAY, LEFT, 2, JrTrainerF, 2
	object SPRITE_BUG_CATCHER, 0, 15, STAY, RIGHT, 3, BugCatcher, 10
	object SPRITE_BLACK_HAIR_BOY_1, 11, 31, STAY, LEFT, 4, JrTrainerM, 5
	object SPRITE_LASS, 11, 30, STAY, LEFT, 5, JrTrainerF, 3
	object SPRITE_BUG_CATCHER, 19, 26, STAY, LEFT, 6, BugCatcher, 11

	; warp-to
	warp_to 9, 1, ROUTE_6_WIDTH ; ROUTE_6_GATE
	warp_to 10, 1, ROUTE_6_WIDTH ; ROUTE_6_GATE
	warp_to 10, 7, ROUTE_6_WIDTH ; ROUTE_6_GATE
	warp_to 17, 13, ROUTE_6_WIDTH ; PATH_ENTRANCE_ROUTE_6
