IndigoPlateauLobby_h:
	db POKECENTER ; tileset
	db INDIGO_PLATEAU_LOBBY_HEIGHT, INDIGO_PLATEAU_LOBBY_WIDTH ; dimensions (y, x)
	dw IndigoPlateauLobbyBlocks, IndigoPlateauLobbyTextPointers, IndigoPlateauLobbyScript, IndigoPlateauLobbyTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw IndigoPlateauLobbyObject ; objects
