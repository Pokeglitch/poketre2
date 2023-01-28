ViridianHouseScript:
	jp EnableAutoTextBoxDrawing

ViridianHouseTrainerHeader0:
	db TrainerHeaderTerminator

ViridianHouseTextPointers:
	dw ViridianHouseText1
	dw ViridianHouseText2
	dw ViridianHouseText3
	dw ViridianHouseText4

ViridianHouseText1:
	fartext _ViridianHouseText1
	done

ViridianHouseText2:
	fartext _ViridianHouseText2
	done

ViridianHouseText3:
	asmtext
	ld hl, ViridianHouseText_1d5b1
	call PrintText
	ld a, SPEAROW
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

ViridianHouseText_1d5b1:
	fartext _ViridianHouseText_1d5b1
	done

ViridianHouseText4:
	fartext _ViridianHouseText4
	done
