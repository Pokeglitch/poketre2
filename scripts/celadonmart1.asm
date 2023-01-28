CeladonMart1Script:
	jp EnableAutoTextBoxDrawing

CeladonMart1TrainerHeader0:
	db TrainerHeaderTerminator

CeladonMart1TextPointers:
	dw CeladonMart1Text1
	dw CeladonMart1Text2
	dw CeladonMart1Text3

CeladonMart1Text1:
	fartext _CeladonMart1Text1
	done

CeladonMart1Text2:
	fartext _CeladonMart1Text2
	done

CeladonMart1Text3:
	fartext _CeladonMart1Text3
	done
