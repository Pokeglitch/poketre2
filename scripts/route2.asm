Route2Script:
	jp EnableAutoTextBoxDrawing

Route2TrainerHeader0:
	db TrainerHeaderTerminator

Route2TextPointers:
	dw PickUpItemText
	dw PickUpItemText
	dw Route2Text3
	dw Route2Text4

Route2Text3:
	fartext _Route2Text3
	done

Route2Text4:
	fartext _Route2Text4
	done
