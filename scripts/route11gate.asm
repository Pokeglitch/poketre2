Route11GateScript:
	jp EnableAutoTextBoxDrawing

Route11GateTrainerHeader0:
	db TrainerHeaderTerminator

Route11GateTextPointers:
	dw Route11GateText1

Route11GateText1:
	fartext _Route11GateText1
	done
