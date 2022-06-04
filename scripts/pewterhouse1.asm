PewterHouse1Script:
	jp EnableAutoTextBoxDrawing

PewterHouse1TextPointers:
	dw PewterHouse1Text1
	dw PewterHouse1Text2
	dw PewterHouse1Text3

PewterHouse1Text1:
	text ""
	fartext _PewterHouse1Text1
	asmtext
	ld a, NIDORAN_M
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

PewterHouse1Text2:
	text ""
	fartext _PewterHouse1Text2
	done

PewterHouse1Text3:
	text ""
	fartext _PewterHouse1Text3
	done
