Route15GateScript:
	jp EnableAutoTextBoxDrawing

Route15GateTrainerHeader0:
	db TrainerHeaderTerminator

Route15GateTextPointers:
	dw Route15GateText1

Route15GateText1:
	fartext _Route15GateText1
	done
