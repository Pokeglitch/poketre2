Lab2Script:
	jp EnableAutoTextBoxDrawing

Lab2TextPointers:
	dw Lab2Text1
	dw Lab2Text2
	dw Lab2Text3

Lab2Text1:
	fartext _Lab2Text1
	done

Lab2Text2:
	asmtext
	ld a, $7
	ld [wWhichTrade], a
	jr Lab2DoTrade

Lab2Text3:
	asmtext
	ld a, $8
	ld [wWhichTrade], a
Lab2DoTrade:
	predef DoInGameTradeDialogue
	jp TextScriptEnd
