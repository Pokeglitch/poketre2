CeruleanHouse1Script:
	jp EnableAutoTextBoxDrawing

CeruleanHouse1TextPointers:
	dw CeruleanHouse1Text1
	dw CeruleanHouse1Text2

CeruleanHouse1Text1:
	fartext _CeruleanHouse1Text1
	done

CeruleanHouse1Text2:
	asmtext
	ld a, $6
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd
