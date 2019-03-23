PewterMartScript:
	call EnableAutoTextBoxDrawing
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	ret

PewterMartTextPointers:
	dw PewterCashierText
	dw PewterMartText2
	dw PewterMartText3

PewterMartText2:
	textbox DONT_REVEAL | NO_DELAY | BLACK_ON_LIGHT | LINES_3
	TX_ASM
	ld hl, .Text
	call PrintText
	jp TextScriptEnd
.Text
	TX_FAR _PewterMartText2
	db "@"

PewterMartText3:
	textbox BLACK_ON_WHITE | NO_DELAY | LINES_2
	TX_ASM
	ld hl, .Text
	call PrintText
	jp TextScriptEnd
.Text
	TX_FAR _PewterMartText3
	db "@"
