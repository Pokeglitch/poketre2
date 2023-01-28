Route7Gate_h:
	db GATE ; tileset
	db ROUTE_7_GATE_HEIGHT, ROUTE_7_GATE_WIDTH ; dimensions (y, x)
	dw Route7GateBlocks, Route7GateTextPointers, Route7GateScript, Route7GateTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw Route7GateObject ; objects
