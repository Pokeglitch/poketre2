Route11Object:
	db $f ; border block

	db 5 ; warps
	warp 49, 8, 0, ROUTE_11_GATE_1F
	warp 49, 9, 1, ROUTE_11_GATE_1F
	warp 58, 8, 2, ROUTE_11_GATE_1F
	warp 58, 9, 3, ROUTE_11_GATE_1F
	warp 4, 5, 0, DIGLETTS_CAVE_ENTRANCE

	db 1 ; signs
	sign 1, 5, 11 ; Route11Text11

	db 10 ; objects
	object SPRITE_GAMBLER, 10, 14, STAY, DOWN, 1, Gambler, 1
	object SPRITE_GAMBLER, 26, 9, STAY, DOWN, 2, Gambler, 2
	object SPRITE_BUG_CATCHER, 13, 5, STAY, LEFT, 3, Youngster, 9
	object SPRITE_BLACK_HAIR_BOY_2, 36, 11, STAY, DOWN, 4, Engineer, 2
	object SPRITE_BUG_CATCHER, 22, 4, STAY, UP, 5, Youngster, 10
	object SPRITE_GAMBLER, 45, 7, STAY, DOWN, 6, Gambler, 3
	object SPRITE_GAMBLER, 33, 3, STAY, UP, 7, Gambler, 4
	object SPRITE_BUG_CATCHER, 43, 5, STAY, RIGHT, 8, Youngster, 11
	object SPRITE_BLACK_HAIR_BOY_2, 45, 16, STAY, LEFT, 9, Engineer, 3
	object SPRITE_BUG_CATCHER, 22, 12, STAY, UP, 10, Youngster, 12

	; warp-to
	warp_to 49, 8, ROUTE_11_WIDTH ; ROUTE_11_GATE_1F
	warp_to 49, 9, ROUTE_11_WIDTH ; ROUTE_11_GATE_1F
	warp_to 58, 8, ROUTE_11_WIDTH ; ROUTE_11_GATE_1F
	warp_to 58, 9, ROUTE_11_WIDTH ; ROUTE_11_GATE_1F
	warp_to 4, 5, ROUTE_11_WIDTH ; DIGLETTS_CAVE_ENTRANCE
