TradeCenter_h:
	db CLUB ; tileset
	db TRADE_CENTER_HEIGHT, TRADE_CENTER_WIDTH ; dimensions (y, x)
	dw TradeCenterBlocks, TradeCenterTextPointers, TradeCenterScript, TradeCenterTrainerHeader0 ; blocks, texts, scripts
	db 0 ; connections
	dw TradeCenterObject ; objects
