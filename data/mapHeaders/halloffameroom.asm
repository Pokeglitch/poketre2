HallofFameRoom_h:
	db GYM ; tileset
	db HALL_OF_FAME_HEIGHT, HALL_OF_FAME_WIDTH ; dimensions (y, x)
	dw HallofFameRoomBlocks, HallofFameRoomTextPointers, HallofFameRoomScript, HallofFameRoomTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw HallofFameRoomObject ; objects
