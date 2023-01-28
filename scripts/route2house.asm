Route2HouseScript:
	jp EnableAutoTextBoxDrawing

Route2HouseTrainerHeader0:
	db TrainerHeaderTerminator

Route2HouseTextPointers:
	dw Route2HouseText1
	dw Route2HouseText2

Route2HouseText1:
	fartext _Route2HouseText1
	done

Route2HouseText2:
	asmtext
	ld a, $1
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd
