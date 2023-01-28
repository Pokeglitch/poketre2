VermilionHouse3Script:
	jp EnableAutoTextBoxDrawing

VermilionHouse3TrainerHeader0:
	db TrainerHeaderTerminator

VermilionHouse3TextPointers:
	dw VermilionHouse3Text1

VermilionHouse3Text1:
	asmtext
	ld a, $4
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd
