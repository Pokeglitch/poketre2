SaffronMartScript:
	jp EnableAutoTextBoxDrawing

SaffronMartTrainerHeader0:
	db TrainerHeaderTerminator

SaffronMartTextPointers:
	dw SaffronCashierText
	dw SaffronMartText2
	dw SaffronMartText3

SaffronMartText2:
	fartext _SaffronMartText2
	done

SaffronMartText3:
	fartext _SaffronMartText3
	done
