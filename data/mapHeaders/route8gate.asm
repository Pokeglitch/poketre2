Route8Gate_h:
	db GATE ; tileset
	db ROUTE_8_GATE_HEIGHT, ROUTE_8_GATE_WIDTH ; dimensions (y, x)
	dw Route8GateBlocks, Route8GateTextPointers, Route8GateScript, Route8GateTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw Route8GateObject ; objects
