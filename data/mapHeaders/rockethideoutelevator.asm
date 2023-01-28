RocketHideoutElevator_h:
	db LOBBY ; tileset
	db ROCKET_HIDEOUT_ELEVATOR_HEIGHT, ROCKET_HIDEOUT_ELEVATOR_WIDTH ; dimensions (y, x)
	dw RocketHideoutElevatorBlocks, RocketHideoutElevatorTextPointers, RocketHideoutElevatorScript, RocketHideoutElevatorTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw RocketHideoutElevatorObject ; objects
