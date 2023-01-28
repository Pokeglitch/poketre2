BluesHouseScript:
	call EnableAutoTextBoxDrawing
	ld hl, BluesHouseScriptPointers
	ld a, [wBluesHouseCurScript]
	jp CallFunctionInTable

BluesHouseScriptPointers:
	dw BluesHouseScript0
	dw BluesHouseScript1

BluesHouseScript0:
	SetEvent EVENT_ENTERED_BLUES_HOUSE

	; trigger the next script
	ld a, 1
	ld [wBluesHouseCurScript], a
	ret

BluesHouseScript1:
	ret

BluesHouseTrainerHeader0:
	db TrainerHeaderTerminator

BluesHouseTextPointers:
	dw BluesHouseText1
	dw BluesHouseText2
	dw BluesHouseText3

BluesHouseText1:
	asmtext
	CheckEvent EVENT_GOT_TOWN_MAP
	jr nz, .GotMap
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .GiveMap
	ld hl, DaisyInitialText
	call PrintText
	jr .done

.GiveMap
	ld hl, DaisyOfferMapText
	call PrintText
	lb bc, TOWN_MAP, 1
	call GiveItem
	jr nc, .BagFull
	ld a, HS_TOWN_MAP
	ld [wMissableObjectIndex], a
	predef HideObject ; hide table map object
	ld hl, GotMapText
	call PrintText
	SetEvent EVENT_GOT_TOWN_MAP
	jr .done

.GotMap
	ld hl, DaisyUseMapText
	call PrintText
	jr .done

.BagFull
	ld hl, DaisyBagFullText
	call PrintText
.done
	jp TextScriptEnd

DaisyInitialText:
	fartext _DaisyInitialText
	done

DaisyOfferMapText:
	fartext _DaisyOfferMapText
	done

GotMapText:
	fartext _GotMapText
	sfxtext SFX_GET_KEY_ITEM
	done

DaisyBagFullText:
	fartext _DaisyBagFullText
	done

DaisyUseMapText:
	fartext _DaisyUseMapText
	done

BluesHouseText2: ; Daisy, walking around
	fartext _BluesHouseText2
	done

BluesHouseText3: ; map on table
	fartext _BluesHouseText3
	done
