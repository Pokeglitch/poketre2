FuchsiaMartScript:
	jp EnableAutoTextBoxDrawing

FuchsiaMartTrainerHeader0:
	db TrainerHeaderTerminator

FuchsiaMartTextPointers:
	dw FuchsiaCashierText
	dw FuchsiaMartText2
	dw FuchsiaMartText3

FuchsiaMartText2:
	fartext _FuchsiaMartText2
	done

FuchsiaMartText3:
	fartext _FuchsiaMartText3
	done
