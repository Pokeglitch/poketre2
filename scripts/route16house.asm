Route16HouseScript:
	jp EnableAutoTextBoxDrawing

Route16HouseTextPointers:
	dw Route16HouseText1
	dw Route16HouseText2

Route16HouseText1:
	asmtext
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
	fartext _Route16HouseText3
	done

ReceivedHM02Text:
	fartext _ReceivedHM02Text
	sfxtext SFX_GET_KEY_ITEM
	done

HM02ExplanationText:
	fartext _HM02ExplanationText
	done

HM02NoRoomText:
	fartext _HM02NoRoomText
	done

Route16HouseText2:
	asmtext
	ld hl, Route16HouseText_1e652
	call PrintText
	ld a, FEAROW
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

Route16HouseText_1e652:
	fartext _Route16HouseText_1e652
	done
