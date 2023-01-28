Route12GateScript:
	jp EnableAutoTextBoxDrawing

Route12GateTrainerHeader0:
	db TrainerHeaderTerminator

Route12GateTextPointers:
	dw Route12GateText1

Route12GateText1:
	fartext _Route12GateText1
	done
