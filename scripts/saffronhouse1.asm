SaffronHouse1Script:
	jp EnableAutoTextBoxDrawing

SaffronHouse1TextPointers:
	dw SaffronHouse1Text1
	dw SaffronHouse1Text2
	dw SaffronHouse1Text3
	dw SaffronHouse1Text4

SaffronHouse1Text1:
	fartext _SaffronHouse1Text1
	done

SaffronHouse1Text2:
	fartext _SaffronHouse1Text2
	asmtext
	ld a, PIDGEY
	call PlayCry
	jp TextScriptEnd

SaffronHouse1Text3:
	fartext _SaffronHouse1Text3
	done

SaffronHouse1Text4:
	fartext _SaffronHouse1Text4
	done
