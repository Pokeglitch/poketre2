CeruleanMartScript:
	jp EnableAutoTextBoxDrawing

CeruleanMartTrainerHeader0:
	db TrainerHeaderTerminator

CeruleanMartTextPointers:
	dw CeruleanCashierText
	dw CeruleanMartText2
	dw CeruleanMartText3

CeruleanMartText2:
	fartext _CeruleanMartText2
	done

CeruleanMartText3:
	fartext _CeruleanMartText3
	done
