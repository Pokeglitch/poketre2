FanClub_h:
	db INTERIOR ; tileset
	db POKEMON_FAN_CLUB_HEIGHT, POKEMON_FAN_CLUB_WIDTH ; dimensions (y, x)
	dw FanClubBlocks, FanClubTextPointers, FanClubScript, FanClubTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw FanClubObject ; objects
