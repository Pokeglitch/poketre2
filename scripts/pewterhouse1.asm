PewterHouse1Script:
	jp EnableAutoTextBoxDrawing

PewterHouse1TextPointers:
	dw PewterHouse1Text1
	dw PewterHouse1Text2
	dw PewterHouse1Text3

PewterHouse1Text1:
	fartext _PewterHouse1Text1
	asmtext
	ld a, NIDORAN_M
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

PewterHouse1Text2:
	fartext _PewterHouse1Text2
	done

PewterHouse1Text3:
	fartext _PewterHouse1Text3
	done
