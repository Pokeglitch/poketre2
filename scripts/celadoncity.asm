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
	fartext _CeladonCityText1
	done

CeladonCityText2:
	fartext _CeladonCityText2
	done

CeladonCityText3:
	fartext _CeladonCityText3
	done

CeladonCityText4:
	fartext _CeladonCityText4
	done

CeladonCityText5:
	asmtext
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
	fartext _TM41PreText
	done

ReceivedTM41Text:
	fartext _ReceivedTM41Text
	sfxtext SFX_GET_ITEM_1
	done

TM41ExplanationText:
	fartext _TM41ExplanationText
	done

TM41NoRoomText:
	fartext _TM41NoRoomText
	done

CeladonCityText6:
	fartext _CeladonCityText6
	done

CeladonCityText7:
	fartext _CeladonCityText7
	asmtext
	ld a, POLIWRATH
	call PlayCry
	jp TextScriptEnd

CeladonCityText8:
	fartext _CeladonCityText8
	done

CeladonCityText9:
	fartext _CeladonCityText9
	done

CeladonCityText10:
	fartext _CeladonCityText10
	done

CeladonCityText11:
	fartext _CeladonCityText11
	done

CeladonCityText13:
	fartext _CeladonCityText13
	done

CeladonCityText14:
	fartext _CeladonCityText14
	done

CeladonCityText15:
	fartext _CeladonCityText15
	done

CeladonCityText16:
	fartext _CeladonCityText16
	done

CeladonCityText17:
	fartext _CeladonCityText17
	done

CeladonCityText18:
	fartext _CeladonCityText18
	done
