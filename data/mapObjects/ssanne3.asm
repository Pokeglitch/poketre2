SSAnne3Object:
	db $c ; border block

	db 2 ; warps
	warp 0, 3, 0, SS_ANNE_5
	warp 19, 3, 7, SS_ANNE_2

	db 0 ; signs

	db 1 ; objects
	object SPRITE_SAILOR, 9, 3, WALK, 2, 1 ; person

	; warp-to
	warp_to 0, 3, SS_ANNE_3_WIDTH ; SS_ANNE_5
	warp_to 19, 3, SS_ANNE_3_WIDTH ; SS_ANNE_2
