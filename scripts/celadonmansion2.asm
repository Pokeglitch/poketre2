CeladonMansion2Script:
	call EnableAutoTextBoxDrawing
	ret

CeladonMansion2TrainerHeader0:
	db TrainerHeaderTerminator

CeladonMansion2TextPointers:
	dw CeladonMansion2Text1

CeladonMansion2Text1:
	fartext _CeladonMansion2Text1
	done
