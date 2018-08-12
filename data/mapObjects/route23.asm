Route23Object:
	db $f ; border block

	db 4 ; warps
	warp 7, 139, 2, ROUTE_22_GATE
	warp 8, 139, 3, ROUTE_22_GATE
	warp 4, 31, 0, VICTORY_ROAD_1
	warp 14, 31, 1, VICTORY_ROAD_2

	db 1 ; signs
	sign 3, 33, 8 ; Route23Text8

	db 7 ; objects
	object SPRITE_GUARD, 4, 35, STAY, DOWN, 1 ; person
	object SPRITE_GUARD, 10, 56, STAY, DOWN, 2 ; person
	object SPRITE_SWIMMER, 8, 85, STAY, DOWN, 3 ; person
	object SPRITE_SWIMMER, 11, 96, STAY, DOWN, 4 ; person
	object SPRITE_GUARD, 12, 105, STAY, DOWN, 5 ; person
	object SPRITE_GUARD, 8, 119, STAY, DOWN, 6 ; person
	object SPRITE_GUARD, 8, 136, STAY, DOWN, 7 ; person

	; warp-to
	warp_to 7, 139, ROUTE_23_WIDTH ; ROUTE_22_GATE
	warp_to 8, 139, ROUTE_23_WIDTH ; ROUTE_22_GATE
	warp_to 4, 31, ROUTE_23_WIDTH ; VICTORY_ROAD_1
	warp_to 14, 31, ROUTE_23_WIDTH ; VICTORY_ROAD_2
