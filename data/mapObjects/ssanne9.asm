SSAnne9Object:
	db $c ; border block

	db 12 ; warps
	warp 2, 5, 0, SS_ANNE_2
	warp 3, 5, 0, SS_ANNE_2
	warp 12, 5, 1, SS_ANNE_2
	warp 13, 5, 1, SS_ANNE_2
	warp 22, 5, 2, SS_ANNE_2
	warp 23, 5, 2, SS_ANNE_2
	warp 2, 15, 3, SS_ANNE_2
	warp 3, 15, 3, SS_ANNE_2
	warp 12, 15, 4, SS_ANNE_2
	warp 13, 15, 4, SS_ANNE_2
	warp 22, 15, 5, SS_ANNE_2
	warp 23, 15, 5, SS_ANNE_2

	db 0 ; signs

	db 13 ; objects
	object SPRITE_GENTLEMAN, 10, 2, STAY, RIGHT, 1, OPP_GENTLEMAN, 3
	object SPRITE_FISHER2, 13, 4, STAY, LEFT, 2, OPP_FISHER, 1
	object SPRITE_GENTLEMAN, 0, 14, STAY, RIGHT, 3, OPP_GENTLEMAN, 5
	object SPRITE_LASS, 2, 11, STAY, DOWN, 4, OPP_LASS, 12
	object SPRITE_GENTLEMAN, 1, 2, STAY, DOWN, 5 ; person
	object SPRITE_BALL, 12, 1, STAY, NONE, 6, MAX_ETHER
	object SPRITE_GENTLEMAN, 21, 2, STAY, DOWN, 7 ; person
	object SPRITE_OLD_PERSON, 22, 1, STAY, DOWN, 8 ; person
	object SPRITE_BALL, 0, 12, STAY, NONE, 9, RARE_CANDY
	object SPRITE_GENTLEMAN, 12, 12, STAY, DOWN, 10 ; person
	object SPRITE_YOUNG_BOY, 11, 14, STAY, NONE, 11 ; person
	object SPRITE_BRUNETTE_GIRL, 22, 12, STAY, LEFT, 12 ; person
	object SPRITE_FOULARD_WOMAN, 20, 12, STAY, RIGHT, 13 ; person

	; warp-to
	warp_to 2, 5, SS_ANNE_9_WIDTH ; SS_ANNE_2
	warp_to 3, 5, SS_ANNE_9_WIDTH ; SS_ANNE_2
	warp_to 12, 5, SS_ANNE_9_WIDTH ; SS_ANNE_2
	warp_to 13, 5, SS_ANNE_9_WIDTH ; SS_ANNE_2
	warp_to 22, 5, SS_ANNE_9_WIDTH ; SS_ANNE_2
	warp_to 23, 5, SS_ANNE_9_WIDTH ; SS_ANNE_2
	warp_to 2, 15, SS_ANNE_9_WIDTH ; SS_ANNE_2
	warp_to 3, 15, SS_ANNE_9_WIDTH ; SS_ANNE_2
	warp_to 12, 15, SS_ANNE_9_WIDTH ; SS_ANNE_2
	warp_to 13, 15, SS_ANNE_9_WIDTH ; SS_ANNE_2
	warp_to 22, 15, SS_ANNE_9_WIDTH ; SS_ANNE_2
	warp_to 23, 15, SS_ANNE_9_WIDTH ; SS_ANNE_2
