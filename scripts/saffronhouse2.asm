SaffronHouse2Script:
	jp EnableAutoTextBoxDrawing

SaffronHouse2TextPointers:
	dw SaffronHouse2Text1

SaffronHouse2Text1:
	asmtext
	CheckEvent EVENT_GOT_TM29
	jr nz, .asm_9e72b
	ld hl, TM29PreReceiveText
	call PrintText
	lb bc, TM_29, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedTM29Text
	call PrintText
	SetEvent EVENT_GOT_TM29
	jr .asm_fe4e1
.BagFull
	ld hl, TM29NoRoomText
	call PrintText
	jr .asm_fe4e1
.asm_9e72b
	ld hl, TM29ExplanationText
	call PrintText
.asm_fe4e1
	jp TextScriptEnd

TM29PreReceiveText:
	fartext _TM29PreReceiveText
	done

ReceivedTM29Text:
	fartext _ReceivedTM29Text
	sfxtext SFX_GET_ITEM_1
	done

TM29ExplanationText:
	fartext _TM29ExplanationText
	done

TM29NoRoomText:
	fartext _TM29NoRoomText
	done
