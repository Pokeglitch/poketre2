Route11Gate_h:
	db GATE ; tileset
	db ROUTE_11_GATE_1F_HEIGHT, ROUTE_11_GATE_1F_WIDTH ; dimensions (y, x)
	dw Route11GateBlocks, Route11GateTextPointers, Route11GateScript, Route11GateTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw Route11GateObject ; objects
