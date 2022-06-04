SafariZoneSecretHouseScript:
	jp EnableAutoTextBoxDrawing

SafariZoneSecretHouseTextPointers:
	dw SafariZoneSecretHouseText1

SafariZoneSecretHouseText1:
	text ""
	asmtext
	CheckEvent EVENT_GOT_HM03
	jr nz, .asm_20a9b
	ld hl, SafariZoneSecretHouseText_4a350
	call PrintText
	lb bc, HM_03, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedHM03Text
	call PrintText
	SetEvent EVENT_GOT_HM03
	jr .asm_8f1fc
.BagFull
	ld hl, HM03NoRoomText
	call PrintText
	jr .asm_8f1fc
.asm_20a9b
	ld hl, HM03ExplanationText
	call PrintText
.asm_8f1fc
	jp TextScriptEnd

SafariZoneSecretHouseText_4a350:
	text ""
	fartext _SecretHouseText_4a350
	done

ReceivedHM03Text:
	text ""
	fartext _ReceivedHM03Text
	sfxtext SFX_GET_ITEM_1
	done

HM03ExplanationText:
	text ""
	fartext _HM03ExplanationText
	done

HM03NoRoomText:
	text ""
	fartext _HM03NoRoomText
	done
