Route16Object:
	db $f ; border block

	db 9 ; warps
	warp 17, 10, 0, ROUTE_16_GATE_1F
	warp 17, 11, 1, ROUTE_16_GATE_1F
	warp 24, 10, 2, ROUTE_16_GATE_1F
	warp 24, 11, 3, ROUTE_16_GATE_1F
	warp 17, 4, 4, ROUTE_16_GATE_1F
	warp 17, 5, 5, ROUTE_16_GATE_1F
	warp 24, 4, 6, ROUTE_16_GATE_1F
	warp 24, 5, 7, ROUTE_16_GATE_1F
	warp 7, 5, 0, ROUTE_16_HOUSE

	db 2 ; signs
	sign 27, 11, 8 ; Route16Text8
	sign 5, 17, 9 ; Route16Text9

	db 7 ; objects
	object SPRITE_BIKER, 17, 12, STAY, LEFT, 1, Biker, 5
	object SPRITE_BIKER, 14, 13, STAY, RIGHT, 2, CueBall, 1
	object SPRITE_BIKER, 11, 12, STAY, UP, 3, CueBall, 2
	object SPRITE_BIKER, 9, 11, STAY, LEFT, 4, Biker, 6
	object SPRITE_BIKER, 6, 10, STAY, RIGHT, 5, CueBall, 3
	object SPRITE_BIKER, 3, 12, STAY, RIGHT, 6, Biker, 7
	object SPRITE_SNORLAX, 26, 10, STAY, DOWN, 7 ; person

	; warp-to
	warp_to 17, 10, ROUTE_16_WIDTH ; ROUTE_16_GATE_1F
	warp_to 17, 11, ROUTE_16_WIDTH ; ROUTE_16_GATE_1F
	warp_to 24, 10, ROUTE_16_WIDTH ; ROUTE_16_GATE_1F
	warp_to 24, 11, ROUTE_16_WIDTH ; ROUTE_16_GATE_1F
	warp_to 17, 4, ROUTE_16_WIDTH ; ROUTE_16_GATE_1F
	warp_to 17, 5, ROUTE_16_WIDTH ; ROUTE_16_GATE_1F
	warp_to 24, 4, ROUTE_16_WIDTH ; ROUTE_16_GATE_1F
	warp_to 24, 5, ROUTE_16_WIDTH ; ROUTE_16_GATE_1F
	warp_to 7, 5, ROUTE_16_WIDTH ; ROUTE_16_HOUSE
