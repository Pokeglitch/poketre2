Route5Gate_h:
	db GATE ; tileset
	db ROUTE_5_GATE_HEIGHT, ROUTE_5_GATE_WIDTH ; dimensions (y, x)
	dw Route5GateBlocks, Route5GateTextPointers, Route5GateScript, Route5GateTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw Route5GateObject ; objects
