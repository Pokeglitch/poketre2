LavenderHouse2Script:
	call EnableAutoTextBoxDrawing
	ret

LavenderHouse2TextPointers:
	dw LavenderHouse2Text1
	dw LavenderHouse2Text2

LavenderHouse2Text1:
	text ""
	fartext _LavenderHouse2Text1
	asmtext
	ld a, CUBONE
	call PlayCry
	jp TextScriptEnd

LavenderHouse2Text2:
	TX_ASM
	CheckEvent EVENT_RESCUED_MR_FUJI
	jr nz, .asm_65711
	ld hl, LavenderHouse2Text_1d9dc
	call PrintText
	jr .asm_64be1
.asm_65711
	ld hl, LavenderHouse2Text_1d9e1
	call PrintText
.asm_64be1
	jp TextScriptEnd

LavenderHouse2Text_1d9dc:
	text ""
	fartext _LavenderHouse2Text_1d9dc
	done

LavenderHouse2Text_1d9e1:
	text ""
	fartext _LavenderHouse2Text_1d9e1
	done
