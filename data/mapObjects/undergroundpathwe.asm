UndergroundPathWEObject:
	db $1 ; border block

	db 2 ; warps
	warp 2, 5, 2, PATH_ENTRANCE_ROUTE_7
	warp 47, 2, 2, PATH_ENTRANCE_ROUTE_8

	db 0 ; signs

	db 0 ; objects

	; warp-to
	warp_to 2, 5, UNDERGROUND_PATH_WE_WIDTH ; PATH_ENTRANCE_ROUTE_7
	warp_to 47, 2, UNDERGROUND_PATH_WE_WIDTH ; PATH_ENTRANCE_ROUTE_8
