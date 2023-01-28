MtMoon2Script:
	call EnableAutoTextBoxDrawing
	ret

MtMoon2TrainerHeader0:
	db TrainerHeaderTerminator

MtMoon2TextPointers:
	dw MtMoonText1

MtMoonText1:
	fartext _MtMoonText1
	done
