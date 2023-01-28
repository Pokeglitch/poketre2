Gary_h:
	db GYM ;tileset
	db CHAMPIONS_ROOM_HEIGHT, CHAMPIONS_ROOM_WIDTH ; Height, Width
	dw GaryBlocks, GaryTextPointers, GaryScript, GaryTrainerHeader0
	db $0 ;No Connections
	dw GaryObject
