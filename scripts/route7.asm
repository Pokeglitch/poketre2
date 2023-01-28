Route7Script:
	jp EnableAutoTextBoxDrawing

Route7TrainerHeader0:
	db TrainerHeaderTerminator

Route7TextPointers:
	dw Route7Text1

Route7Text1:
	fartext _Route7Text1
	done
