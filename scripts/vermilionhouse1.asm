VermilionHouse1Script:
	call EnableAutoTextBoxDrawing
	ret

VermilionHouse1TextPointers:
	dw VermilionHouse1Text1
	dw VermilionHouse1Text2
	dw VermilionHouse1Text3

VermilionHouse1Text1:
	text ""
	fartext _VermilionHouse1Text1
	done

VermilionHouse1Text2:
	text ""
	fartext _VermilionHouse1Text2
	asmtext
	ld a, PIDGEY
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

VermilionHouse1Text3:
	text ""
	fartext _VermilionHouse1Text3
	done
