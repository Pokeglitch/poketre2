CeladonMartElevator_h:
	db LOBBY ; tileset
	db CELADON_MART_ELEVATOR_HEIGHT, CELADON_MART_ELEVATOR_WIDTH ; dimensions (y, x)
	dw CeladonMartElevatorBlocks, CeladonMartElevatorTextPointers, CeladonMartElevatorScript, CeladonMartElevatorTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw CeladonMartElevatorObject ; objects
