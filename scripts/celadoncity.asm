CeladonCityScript:
	call EnableAutoTextBoxDrawing
	ResetEvents EVENT_1B8, EVENT_1BF
	ResetEvent EVENT_67F
	ret

CeladonCityTextPointers:
	dw CeladonCityText1
	dw CeladonCityText2
	dw CeladonCityText3
	dw CeladonCityText4
	dw CeladonCityText5
	dw CeladonCityText6
	dw CeladonCityText7
	dw CeladonCityText8
	dw CeladonCityText9
	dw CeladonCityText10
	dw CeladonCityText11
	dw PokeCenterSignText
	dw CeladonCityText13
	dw CeladonCityText14
	dw CeladonCityText15
	dw CeladonCityText16
	dw CeladonCityText17
	dw CeladonCityText18

CeladonCityText1:
	text ""
	fartext _CeladonCityText1
	done

CeladonCityText2:
	text ""
	fartext _CeladonCityText2
	done

CeladonCityText3:
	text ""
	fartext _CeladonCityText3
	done

CeladonCityText4:
	text ""
	fartext _CeladonCityText4
	done

CeladonCityText5:
	TX_ASM
	CheckEvent EVENT_GOT_TM41
	jr nz, .asm_7053f
	ld hl, TM41PreText
	call PrintText
	lb bc, TM_41, 1
	call GiveItem
	jr c, .Success
	ld hl, TM41NoRoomText
	call PrintText
	jr .Done
.Success
	ld hl, ReceivedTM41Text
	call PrintText
	SetEvent EVENT_GOT_TM41
	jr .Done
.asm_7053f
	ld hl, TM41ExplanationText
	call PrintText
.Done
	jp TextScriptEnd

TM41PreText:
	text ""
	fartext _TM41PreText
	done

ReceivedTM41Text:
	text ""
	fartext _ReceivedTM41Text
	sfxtext SFX_GET_ITEM_1
	done

TM41ExplanationText:
	text ""
	fartext _TM41ExplanationText
	done

TM41NoRoomText:
	text ""
	fartext _TM41NoRoomText
	done

CeladonCityText6:
	text ""
	fartext _CeladonCityText6
	done

CeladonCityText7:
	text ""
	fartext _CeladonCityText7
	asmtext
	ld a, POLIWRATH
	call PlayCry
	jp TextScriptEnd

CeladonCityText8:
	text ""
	fartext _CeladonCityText8
	done

CeladonCityText9:
	text ""
	fartext _CeladonCityText9
	done

CeladonCityText10:
	text ""
	fartext _CeladonCityText10
	done

CeladonCityText11:
	text ""
	fartext _CeladonCityText11
	done

CeladonCityText13:
	text ""
	fartext _CeladonCityText13
	done

CeladonCityText14:
	text ""
	fartext _CeladonCityText14
	done

CeladonCityText15:
	text ""
	fartext _CeladonCityText15
	done

CeladonCityText16:
	text ""
	fartext _CeladonCityText16
	done

CeladonCityText17:
	text ""
	fartext _CeladonCityText17
	done

CeladonCityText18:
	text ""
	fartext _CeladonCityText18
	done
