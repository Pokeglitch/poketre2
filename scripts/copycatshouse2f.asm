CopycatsHouse2FScript:
	jp EnableAutoTextBoxDrawing

CopycatsHouse2FTextPointers:
	dw CopycatsHouse2FText1
	dw CopycatsHouse2FText2
	dw CopycatsHouse2FText3
	dw CopycatsHouse2FText4
	dw CopycatsHouse2FText5
	dw CopycatsHouse2FText6
	dw CopycatsHouse2FText7

CopycatsHouse2FText1:
	TX_ASM
	CheckEvent EVENT_GOT_TM31
	jr nz, .asm_7ccf3
	ld a, $1
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	ld hl, CopycatsHouse2FText_5ccd4
	call PrintText
	ld b, POKE_DOLL
	call IsItemInBag
	jr z, .asm_62ecd
	ld hl, TM31PreReceiveText
	call PrintText
	lb bc, TM_31, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedTM31Text
	call PrintText
	ld a, POKE_DOLL
	ld [$ffdb], a
	callba RemoveItemByID
	SetEvent EVENT_GOT_TM31
	jr .asm_62ecd
.BagFull
	ld hl, TM31NoRoomText
	call PrintText
	jr .asm_62ecd
.asm_7ccf3
	ld hl, TM31ExplanationText2
	call PrintText
.asm_62ecd
	jp TextScriptEnd

CopycatsHouse2FText_5ccd4:
	text ""
	fartext _CopycatsHouse2FText_5ccd4
	done

TM31PreReceiveText:
	text ""
	fartext _TM31PreReceiveText
	done

ReceivedTM31Text:
	text ""
	fartext _ReceivedTM31Text
	sfxtext SFX_GET_ITEM_1

TM31ExplanationText1:
	text ""
	fartext _TM31ExplanationText1
	wait
	done

TM31ExplanationText2:
	text ""
	fartext _TM31ExplanationText2
	done

TM31NoRoomText:
	text ""
	fartext _TM31NoRoomText
	wait
	done

CopycatsHouse2FText2:
	text ""
	fartext _CopycatsHouse2FText2
	done

CopycatsHouse2FText5:
CopycatsHouse2FText4:
CopycatsHouse2FText3:
	text ""
	fartext _CopycatsHouse2FText3
	done

CopycatsHouse2FText6:
	text ""
	fartext _CopycatsHouse2FText6
	done

CopycatsHouse2FText7:
	TX_ASM
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_UP
	ld hl, CopycatsHouse2FText_5cd1c
	jr nz, .notUp
	ld hl, CopycatsHouse2FText_5cd17
.notUp
	call PrintText
	jp TextScriptEnd

CopycatsHouse2FText_5cd17:
	text ""
	fartext _CopycatsHouse2FText_5cd17
	done

CopycatsHouse2FText_5cd1c:
	text ""
	fartext _CopycatsHouse2FText_5cd1c
	done
