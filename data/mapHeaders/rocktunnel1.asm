RockTunnel1_h:
	db CAVERN ; tileset
	db ROCK_TUNNEL_1_HEIGHT, ROCK_TUNNEL_1_WIDTH ; dimensions (y, x)
	dw RockTunnel1Blocks, RockTunnel1TextPointers, RockTunnel1Script, RockTunnel1TrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw RockTunnel1Object ; objects
