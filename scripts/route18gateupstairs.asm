Route18GateUpstairsScript:
	jp DisableAutoTextBoxDrawing

Route18GateUpstairsTrainerHeader0:
	db TrainerHeaderTerminator

Route18GateUpstairsTextPointers:
	dw Route18GateUpstairsText1
	dw Route18GateUpstairsText2
	dw Route18GateUpstairsText3

Route18GateUpstairsText1:
	asmtext
	ld a, $5
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd

Route18GateUpstairsText2:
	asmtext
	ld hl, Route18GateUpstairsText_49993
	jp GateUpstairsScript_PrintIfFacingUp

Route18GateUpstairsText_49993:
	fartext _Route18GateUpstairsText_49993
	done

Route18GateUpstairsText3:
	asmtext
	ld hl, Route18GateUpstairsText_4999f
	jp GateUpstairsScript_PrintIfFacingUp

Route18GateUpstairsText_4999f:
	fartext _Route18GateUpstairsText_4999f
	done
