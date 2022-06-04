ViridianHouseScript:
	jp EnableAutoTextBoxDrawing

ViridianHouseTextPointers:
	dw ViridianHouseText1
	dw ViridianHouseText2
	dw ViridianHouseText3
	dw ViridianHouseText4

ViridianHouseText1:
	text ""
	fartext _ViridianHouseText1
	done

ViridianHouseText2:
	text ""
	fartext _ViridianHouseText2
	done

ViridianHouseText3:
	TX_ASM
	ld hl, ViridianHouseText_1d5b1
	call PrintText
	ld a, SPEAROW
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

ViridianHouseText_1d5b1:
	text ""
	fartext _ViridianHouseText_1d5b1
	done

ViridianHouseText4:
	text ""
	fartext _ViridianHouseText4
	done
