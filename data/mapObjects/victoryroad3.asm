VictoryRoad3Object:
	db $7d ; border block

	db 4 ; warps
	warp 23, 7, 3, VICTORY_ROAD_2
	warp 26, 8, 5, VICTORY_ROAD_2
	warp 27, 15, 4, VICTORY_ROAD_2
	warp 2, 0, 6, VICTORY_ROAD_2

	db 0 ; signs

	db 10 ; objects
	object SPRITE_BLACK_HAIR_BOY_1, 28, 5, STAY, LEFT, 1, CooltrainerM, 2
	object SPRITE_LASS, 7, 13, STAY, RIGHT, 2, CooltrainerF, 2
	object SPRITE_BLACK_HAIR_BOY_1, 6, 14, STAY, LEFT, 3, CooltrainerM, 3
	object SPRITE_LASS, 13, 3, STAY, RIGHT, 4, CooltrainerF, 3
	object SPRITE_BALL, 26, 5, STAY, NONE, 5, MAX_REVIVE
	object SPRITE_BALL, 7, 7, STAY, NONE, 6, TM_47
	object SPRITE_BOULDER, 22, 3, STAY, BOULDER_MOVEMENT_BYTE_2, 7 ; person
	object SPRITE_BOULDER, 13, 12, STAY, BOULDER_MOVEMENT_BYTE_2, 8 ; person
	object SPRITE_BOULDER, 24, 10, STAY, BOULDER_MOVEMENT_BYTE_2, 9 ; person
	object SPRITE_BOULDER, 22, 15, STAY, BOULDER_MOVEMENT_BYTE_2, 10 ; person

	; warp-to
	warp_to 23, 7, VICTORY_ROAD_3_WIDTH ; VICTORY_ROAD_2
	warp_to 26, 8, VICTORY_ROAD_3_WIDTH ; VICTORY_ROAD_2
	warp_to 27, 15, VICTORY_ROAD_3_WIDTH ; VICTORY_ROAD_2
	warp_to 2, 0, VICTORY_ROAD_3_WIDTH ; VICTORY_ROAD_2
