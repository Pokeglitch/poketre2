CinnabarMartScript:
	jp EnableAutoTextBoxDrawing

CinnabarMartTrainerHeader0:
	db TrainerHeaderTerminator

CinnabarMartTextPointers:
	dw CinnabarCashierText
	dw CinnabarMartText2
	dw CinnabarMartText3

CinnabarMartText2:
	fartext _CinnabarMartText2
	done

CinnabarMartText3:
	fartext _CinnabarMartText3
	done
