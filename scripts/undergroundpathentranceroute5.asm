UndergroundPathEntranceRoute5Script:
	ld a, ROUTE_5
	ld [wLastMap], a
	ret

UndergroundPathEntranceRoute5_5d6af:
	db "@"

UndergroundPathEntranceRoute5TrainerHeader0:
	db TrainerHeaderTerminator

UndergroundPathEntranceRoute5TextPointers:
	dw UndergroundPathEntranceRoute5Text1

UndergroundPathEntranceRoute5Text1:
	asmtext
	ld a, $9
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	ld hl, UndergroundPathEntranceRoute5_5d6af
	ret
