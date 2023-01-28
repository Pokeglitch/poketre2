CeladonMart4Script:
	jp EnableAutoTextBoxDrawing

CeladonMart4TrainerHeader0:
	db TrainerHeaderTerminator

CeladonMart4TextPointers:
	dw CeladonMart4ClerkText
	dw CeladonMart4Text2
	dw CeladonMart4Text3
	dw CeladonMart4Text4

CeladonMart4Text2:
	fartext _CeladonMart4Text2
	done

CeladonMart4Text3:
	fartext _CeladonMart4Text3
	done

CeladonMart4Text4:
	fartext _CeladonMart4Text4
	done
