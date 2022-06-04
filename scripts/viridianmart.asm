ViridianMartScript:
	call ViridianMartScript_1d47d
	call EnableAutoTextBoxDrawing
	ld hl, ViridianMartScriptPointers
	ld a, [wViridianMarketCurScript]
	jp CallFunctionInTable

ViridianMartScript_1d47d:
	CheckEvent EVENT_OAK_GOT_PARCEL
	jr nz, .asm_1d489
	ld hl, ViridianMartTextPointers
	jr .asm_1d48c
.asm_1d489
	ld hl, ViridianMartTextPointers + $a ; starts at ViridianMartText6
.asm_1d48c
	ld a, l
	ld [wMapTextPtr], a
	ld a, h
	ld [wMapTextPtr+1], a
	ret

ViridianMartScriptPointers:
	dw ViridianMartScript0
	dw ViridianMartScript1
	dw ViridianMartScript2

ViridianMartScript0:
	call UpdateSprites
	ld a, $4
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RLEMovement1d4bb
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wViridianMarketCurScript], a
	ret

RLEMovement1d4bb:
	db D_LEFT, $01
	db D_UP, $02
	db $ff

ViridianMartScript1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, $5
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	lb bc, OAKS_PARCEL, 1
	call GiveItem
	SetEvent EVENT_GOT_OAKS_PARCEL
	ld a, $2
	ld [wViridianMarketCurScript], a
	; fallthrough
ViridianMartScript2:
	ret

ViridianMartTextPointers:
	dw ViridianMartText1
	dw ViridianMartText2
	dw ViridianMartText3
	dw ViridianMartText4
	dw ViridianMartText5
	dw ViridianCashierText
	dw ViridianMartText2
	dw ViridianMartText3

ViridianMartText1:
	text ""
	fartext _ViridianMartText1
	done

ViridianMartText4:
	text ""
	fartext _ViridianMartText4
	done

ViridianMartText5:
	text ""
	fartext ViridianMartParcelQuestText
	sfxtext SFX_GET_KEY_ITEM
	done

ViridianMartText2:
	text ""
	fartext _ViridianMartText2
	done

ViridianMartText3:
	text ""
	fartext _ViridianMartText3
	done
