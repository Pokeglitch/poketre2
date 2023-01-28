Route5Script:
	jp EnableAutoTextBoxDrawing

Route5TrainerHeader0:
	db TrainerHeaderTerminator

Route5TextPointers:
	dw Route5Text1

Route5Text1:
	fartext _Route5Text1
	done
