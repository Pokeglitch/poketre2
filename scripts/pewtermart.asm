PewterMartScript:
	call EnableAutoTextBoxDrawing
	ld a, $1
	ld [wAutoTextBoxDrawingControl], a
	ret

PewterMartTrainerHeader0:
	db TrainerHeaderTerminator

PewterMartTextPointers:
	dw PewterCashierText
	dw PewterMartText2
	dw PewterMartText3

PewterMartText2:
	textbox DONT_REVEAL | NO_DELAY | BLACK_ON_LIGHT | LINES_3
	text
	fartext _PewterMartText2
	done

PewterMartText3:
	textbox GLYPHS | NO_DELAY | LINES_1
	text
	fartext _PewterMartText3
	done
