LavenderHouse2Script:
	call EnableAutoTextBoxDrawing
	ret

LavenderHouse2TrainerHeader0:
	db TrainerHeaderTerminator

LavenderHouse2TextPointers:
	dw LavenderHouse2Text1
	dw LavenderHouse2Text2

LavenderHouse2Text1:
	fartext _LavenderHouse2Text1
	asmtext
	ld a, CUBONE
	call PlayCry
	jp TextScriptEnd

LavenderHouse2Text2:
	asmtext
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
	fartext _LavenderHouse2Text_1d9dc
	done

LavenderHouse2Text_1d9e1:
	fartext _LavenderHouse2Text_1d9e1
	done
