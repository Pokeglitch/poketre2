ViridianForestExitScript:
	jp EnableAutoTextBoxDrawing

ViridianForestExitTrainerHeader0:
	db TrainerHeaderTerminator

ViridianForestExitTextPointers:
	dw ViridianForestExitText1
	dw ViridianForestExitText2

ViridianForestExitText1:
	fartext _ViridianForestExitText1
	done

ViridianForestExitText2:
	fartext _ViridianForestExitText2
	done
