Route12GateUpstairs_h:
	db GATE ; tileset
	db ROUTE_12_GATE_2F_HEIGHT, ROUTE_12_GATE_2F_WIDTH ; dimensions (y, x)
	dw Route12GateUpstairsBlocks, Route12GateUpstairsTextPointers, Route12GateUpstairsScript, Route12GateUpstairsTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw Route12GateUpstairsObject ; objects
