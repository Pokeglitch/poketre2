VermilionMartScript:
	jp EnableAutoTextBoxDrawing

VermilionMartTrainerHeader0:
	db TrainerHeaderTerminator

VermilionMartTextPointers:
	dw VermilionCashierText
	dw VermilionMartText2
	dw VermilionMartText3

VermilionMartText2:
	fartext _VermilionMartText2
	done

VermilionMartText3:
	fartext _VermilionMartText3
	done
