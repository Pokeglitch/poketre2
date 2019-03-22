PewterMartScript:
	call EnableAutoTextBoxDrawing
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	ret

PewterMartTextPointers:
	db 0
	dbw BLACK_ON_WHITE | LINES_4, PewterCashierText
	dbw DRAW_BORDER | BLACK_ON_LIGHT | LINES_3, PewterMartText2
	dbw WHITE_ON_BLACK | LINES_2, PewterMartText3

PewterMartText2:
	TX_ASM
	ld hl, .Text
	call PrintText
	jp TextScriptEnd
.Text
	TX_FAR _PewterMartText2
	db "@"

PewterMartText3:
	TX_ASM
	ld hl, .Text
	call PrintText
	jp TextScriptEnd
.Text
	TX_FAR _PewterMartText3
	db "@"
