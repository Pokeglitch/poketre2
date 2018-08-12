Mansion3Object:
	db $1 ; border block

	db 3 ; warps
	warp 7, 10, 1, MANSION_2
	warp 6, 1, 3, MANSION_2
	warp 25, 14, 2, MANSION_2

	db 0 ; signs

	db 5 ; objects
	object SPRITE_BLACK_HAIR_BOY_2, 5, 11, WALK, 2, 1, OPP_BURGLAR, 8
	object SPRITE_OAK_AIDE, 20, 11, STAY, LEFT, 2, OPP_SCIENTIST, 12
	object SPRITE_BALL, 1, 16, STAY, NONE, 3, MAX_POTION
	object SPRITE_BALL, 25, 5, STAY, NONE, 4, IRON
	object SPRITE_BOOK_MAP_DEX, 6, 12, STAY, NONE, 5 ; person

	; warp-to
	warp_to 7, 10, MANSION_3_WIDTH ; MANSION_2
	warp_to 6, 1, MANSION_3_WIDTH ; MANSION_2
	warp_to 25, 14, MANSION_3_WIDTH ; MANSION_2
