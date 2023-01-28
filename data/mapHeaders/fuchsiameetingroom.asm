FuchsiaMeetingRoom_h:
	db LAB ; tileset
	db FUCHSIA_MEETING_ROOM_HEIGHT, FUCHSIA_MEETING_ROOM_WIDTH ; dimensions (y, x)
	dw FuchsiaMeetingRoomBlocks, FuchsiaMeetingRoomTextPointers, FuchsiaMeetingRoomScript, FuchsiaMeetingRoomTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw FuchsiaMeetingRoomObject ; objects
