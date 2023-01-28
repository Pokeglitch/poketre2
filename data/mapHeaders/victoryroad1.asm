VictoryRoad1_h:
	db CAVERN ; tileset
	db VICTORY_ROAD_1_HEIGHT, VICTORY_ROAD_1_WIDTH ; dimensions (y, x)
	dw VictoryRoad1Blocks, VictoryRoad1TextPointers, VictoryRoad1Script, VictoryRoad1TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw VictoryRoad1Object ; objects
