Route16HouseScript:
	jp EnableAutoTextBoxDrawing

Route16HouseTextPointers:
	dw Route16HouseText1
	dw Route16HouseText2

Route16HouseText1:
	TX_ASM
	CheckEvent EVENT_GOT_HM02
	ld hl, HM02ExplanationText
	jr nz, .asm_13616
	ld hl, Route16HouseText3
	call PrintText
	lb bc, HM_02, 1
	call GiveItem
	jr nc, .BagFull
	SetEvent EVENT_GOT_HM02
	ld hl, ReceivedHM02Text
	jr .asm_13616
.BagFull
	ld hl, HM02NoRoomText
.asm_13616
	call PrintText
	jp TextScriptEnd

Route16HouseText3:
	text ""
	fartext _Route16HouseText3
	done

ReceivedHM02Text:
	text ""
	fartext _ReceivedHM02Text
	sfxtext SFX_GET_KEY_ITEM
	done

HM02ExplanationText:
	text ""
	fartext _HM02ExplanationText
	done

HM02NoRoomText:
	text ""
	fartext _HM02NoRoomText
	done

Route16HouseText2:
	TX_ASM
	ld hl, Route16HouseText_1e652
	call PrintText
	ld a, FEAROW
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

Route16HouseText_1e652:
	text ""
	fartext _Route16HouseText_1e652
	done
