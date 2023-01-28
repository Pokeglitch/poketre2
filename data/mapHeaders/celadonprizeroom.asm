CeladonPrizeRoom_h:
	db LOBBY ; tileset
	db CELADON_PRIZE_ROOM_HEIGHT, CELADON_PRIZE_ROOM_WIDTH ; dimensions (y, x)
	dw CeladonPrizeRoomBlocks, CeladonPrizeRoomTextPointers, CeladonPrizeRoomScript, CeladonPrizeRoomTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonPrizeRoomObject ; objects
