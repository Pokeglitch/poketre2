CeruleanHouseTrashedScript:
	call EnableAutoTextBoxDrawing
	ret

CeruleanHouseTrashedTextPointers:
	dw CeruleanHouseTrashedText1
	dw CeruleanHouseTrashedText2
	dw CeruleanHouseTrashedText3

CeruleanHouseTrashedText1:
	text ""
	asmtext
	ld b, $e4
	predef GetQuantityOfItemInBag
	and b
	jr z, .asm_f8734
	ld hl, CeruleanHouseTrashedText_1d6b0
	call PrintText
	jr .asm_8dfe9
.asm_f8734
	ld hl, CeruleanHouseTrashedText_1d6ab
	call PrintText
.asm_8dfe9
	jp TextScriptEnd

CeruleanHouseTrashedText_1d6ab:
	text ""
	fartext _CeruleanTrashedText_1d6ab
	done

CeruleanHouseTrashedText_1d6b0:
	text ""
	fartext _CeruleanTrashedText_1d6b0
	done

CeruleanHouseTrashedText2:
	text ""
	fartext _CeruleanHouseTrashedText2
	done

CeruleanHouseTrashedText3:
	text ""
	fartext _CeruleanHouseTrashedText3
	done
