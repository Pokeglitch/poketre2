LavenderHouse1Script:
	call EnableAutoTextBoxDrawing
	ret

LavenderHouse1TrainerHeader0:
	db TrainerHeaderTerminator

LavenderHouse1TextPointers:
	dw LavenderHouse1Text1
	dw LavenderHouse1Text2
	dw LavenderHouse1Text3
	dw LavenderHouse1Text4
	dw LavenderHouse1Text5
	dw LavenderHouse1Text6

LavenderHouse1Text1:
	asmtext
	CheckEvent EVENT_RESCUED_MR_FUJI
	jr nz, .asm_72e5d
	ld hl, LavenderHouse1Text_1d8d1
	call PrintText
	jr .asm_6957f
.asm_72e5d
	ld hl, LavenderHouse1Text_1d8d6
	call PrintText
.asm_6957f
	jp TextScriptEnd

LavenderHouse1Text_1d8d1:
	fartext _LavenderHouse1Text_1d8d1
	done

LavenderHouse1Text_1d8d6:
	fartext _LavenderHouse1Text_1d8d6
	done

LavenderHouse1Text2:
	asmtext
	CheckEvent EVENT_RESCUED_MR_FUJI
	jr nz, .asm_06470
	ld hl, LavenderHouse1Text_1d8f4
	call PrintText
	jr .asm_3d208
.asm_06470
	ld hl, LavenderHouse1Text_1d8f9
	call PrintText
.asm_3d208
	jp TextScriptEnd

LavenderHouse1Text_1d8f4:
	fartext _LavenderHouse1Text_1d8f4
	done

LavenderHouse1Text_1d8f9:
	fartext _LavenderHouse1Text_1d8f9
	done

LavenderHouse1Text3:
	fartext _LavenderHouse1Text3
	asmtext
	ld a, PSYDUCK
	call PlayCry
	jp TextScriptEnd

LavenderHouse1Text4:
	fartext _LavenderHouse1Text4
	asmtext
	ld a, NIDORINO
	call PlayCry
	jp TextScriptEnd

LavenderHouse1Text5:
	asmtext
	CheckEvent EVENT_GOT_POKE_FLUTE
	jr nz, .asm_15ac2
	ld hl, LavenderHouse1Text_1d94c
	call PrintText
	lb bc, POKE_FLUTE, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedFluteText
	call PrintText
	SetEvent EVENT_GOT_POKE_FLUTE
	jr .asm_da749
.BagFull
	ld hl, FluteNoRoomText
	call PrintText
	jr .asm_da749
.asm_15ac2
	ld hl, MrFujiAfterFluteText
	call PrintText
.asm_da749
	jp TextScriptEnd

LavenderHouse1Text_1d94c:
	fartext _LavenderHouse1Text_1d94c
	done

ReceivedFluteText:
	fartext _ReceivedFluteText
	sfxtext SFX_GET_KEY_ITEM
	fartext _FluteExplanationText
	done

FluteNoRoomText:
	fartext _FluteNoRoomText
	done

MrFujiAfterFluteText:
	fartext _MrFujiAfterFluteText
	done

LavenderHouse1Text6:
	fartext _LavenderHouse1Text6
	done
