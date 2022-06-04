CeladonHouseScript:
	call EnableAutoTextBoxDrawing
	ret

CeladonHouseTextPointers:
	dw CeladonHouseText1
	dw CeladonHouseText2
	dw CeladonHouseText3

CeladonHouseText1:
	fartext _CeladonHouseText1
	done

CeladonHouseText2:
	fartext _CeladonHouseText2
	done

CeladonHouseText3:
	fartext _CeladonHouseText3
	done
