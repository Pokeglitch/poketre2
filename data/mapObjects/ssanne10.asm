SSAnne10Object:
	db $c ; border block

	db 10 ; warps
	warp 2, 5, 4, SS_ANNE_4
	warp 3, 5, 4, SS_ANNE_4
	warp 12, 5, 3, SS_ANNE_4
	warp 13, 5, 3, SS_ANNE_4
	warp 22, 5, 2, SS_ANNE_4
	warp 23, 5, 2, SS_ANNE_4
	warp 2, 15, 1, SS_ANNE_4
	warp 3, 15, 1, SS_ANNE_4
	warp 12, 15, 0, SS_ANNE_4
	warp 13, 15, 0, SS_ANNE_4

	db 0 ; signs

	db 11 ; objects
	object SPRITE_SAILOR, 0, 13, STAY, DOWN, 1, OPP_SAILOR, 3
	object SPRITE_SAILOR, 2, 11, STAY, DOWN, 2, OPP_SAILOR, 4
	object SPRITE_SAILOR, 12, 3, STAY, LEFT, 3, OPP_SAILOR, 5
	object SPRITE_SAILOR, 22, 2, STAY, DOWN, 4, OPP_SAILOR, 6
	object SPRITE_SAILOR, 0, 2, STAY, RIGHT, 5, OPP_SAILOR, 7
	object SPRITE_FISHER2, 0, 4, STAY, RIGHT, 6, OPP_FISHER, 2
	object SPRITE_BLACK_HAIR_BOY_2, 10, 13, STAY, RIGHT, 7 ; person
	object SPRITE_SLOWBRO, 11, 12, STAY, NONE, 8 ; person
	object SPRITE_BALL, 20, 2, STAY, NONE, 9, ETHER
	object SPRITE_BALL, 10, 2, STAY, NONE, 10, TM_44
	object SPRITE_BALL, 12, 11, STAY, NONE, 11, MAX_POTION

	; warp-to
	warp_to 2, 5, SS_ANNE_10_WIDTH ; SS_ANNE_4
	warp_to 3, 5, SS_ANNE_10_WIDTH ; SS_ANNE_4
	warp_to 12, 5, SS_ANNE_10_WIDTH ; SS_ANNE_4
	warp_to 13, 5, SS_ANNE_10_WIDTH ; SS_ANNE_4
	warp_to 22, 5, SS_ANNE_10_WIDTH ; SS_ANNE_4
	warp_to 23, 5, SS_ANNE_10_WIDTH ; SS_ANNE_4
	warp_to 2, 15, SS_ANNE_10_WIDTH ; SS_ANNE_4
	warp_to 3, 15, SS_ANNE_10_WIDTH ; SS_ANNE_4
	warp_to 12, 15, SS_ANNE_10_WIDTH ; SS_ANNE_4
	warp_to 13, 15, SS_ANNE_10_WIDTH ; SS_ANNE_4
