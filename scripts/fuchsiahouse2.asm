FuchsiaHouse2Script:
	jp EnableAutoTextBoxDrawing

FuchsiaHouse2TextPointers:
	dw FuchsiaHouse2Text1
	dw PickUpItemText
	dw BoulderText
	dw FuchsiaHouse2Text4
	dw FuchsiaHouse2Text5

FuchsiaHouse2Text1:
	text ""
	asmtext
	CheckEvent EVENT_GOT_HM04
	jr nz, .subtract
	ld b, GOLD_TEETH
	call IsItemInBag
	jr nz, .asm_3f30f
	CheckEvent EVENT_GAVE_GOLD_TEETH
	jr nz, .asm_60cba
	ld hl, WardenGibberishText1
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, WardenGibberishText3
	jr nz, .asm_61238
	ld hl, WardenGibberishText2
.asm_61238
	call PrintText
	jr .asm_52039
.asm_3f30f
	ld hl, WardenTeethText1
	call PrintText
	ld a, GOLD_TEETH
	ld [$ffdb], a
	callba RemoveItemByID
	SetEvent EVENT_GAVE_GOLD_TEETH
.asm_60cba
	ld hl, WardenThankYouText
	call PrintText
	lb bc, HM_04, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedHM04Text
	call PrintText
	SetEvent EVENT_GOT_HM04
	jr .asm_52039
.subtract
	ld hl, HM04ExplanationText
	call PrintText
	jr .asm_52039
.BagFull
	ld hl, HM04NoRoomText
	call PrintText
.asm_52039
	jp TextScriptEnd

WardenGibberishText1:
	text ""
	fartext _WardenGibberishText1
	done

WardenGibberishText2:
	text ""
	fartext _WardenGibberishText2
	done

WardenGibberishText3:
	text ""
	fartext _WardenGibberishText3
	done

WardenTeethText1:
	text ""
	fartext _WardenTeethText1
	sfxtext SFX_GET_ITEM_1

WardenTeethText2:
	text ""
	fartext _WardenTeethText2
	done

WardenThankYouText:
	text ""
	fartext _WardenThankYouText
	done

ReceivedHM04Text:
	text ""
	fartext _ReceivedHM04Text
	sfxtext SFX_GET_ITEM_1
	done

HM04ExplanationText:
	text ""
	fartext _HM04ExplanationText
	done

HM04NoRoomText:
	text ""
	fartext _HM04NoRoomText
	done

FuchsiaHouse2Text5:
FuchsiaHouse2Text4:
	text ""
	asmtext
	ld a, [H_SPRITEINDEX]
	cp $4
	ld hl, FuchsiaHouse2Text_7517b
	jr nz, .asm_4c9a2
	ld hl, FuchsiaHouse2Text_75176
.asm_4c9a2
	call PrintText
	jp TextScriptEnd

FuchsiaHouse2Text_75176:
	text ""
	fartext _FuchsiaHouse2Text_75176
	done

FuchsiaHouse2Text_7517b:
	text ""
	fartext _FuchsiaHouse2Text_7517b
	done
