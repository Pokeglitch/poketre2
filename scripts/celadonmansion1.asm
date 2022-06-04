CeladonMansion1Script:
	jp EnableAutoTextBoxDrawing

CeladonMansion1TextPointers:
	dw CeladonMansion1Text1
	dw CeladonMansion1Text2
	dw CeladonMansion1Text3
	dw CeladonMansion1Text4
	dw CeladonMansion1Text5

CeladonMansion1_486a1:
	call PlayCry
	jp TextScriptEnd

CeladonMansion1Text1:
	text ""
	fartext _CeladonMansion1Text1
	asmtext
	ld a, MEOWTH
	jp CeladonMansion1_486a1

CeladonMansion1Text2:
	text ""
	fartext _CeladonMansion1Text2
	done

CeladonMansion1Text3:
	text ""
	fartext _CeladonMansion1Text3
	asmtext
	ld a, CLEFAIRY
	jp CeladonMansion1_486a1

CeladonMansion1Text4:
	text ""
	fartext _CeladonMansion1Text4
	asmtext
	ld a, NIDORAN_F
	jp CeladonMansion1_486a1

CeladonMansion1Text5:
	text ""
	fartext _CeladonMansion1Text5
	done
