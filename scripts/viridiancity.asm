ViridianCityScript:
	call EnableAutoTextBoxDrawing
	ld hl, ViridianCityScriptPointers
	ld a, [wViridianCityCurScript]
	jp CallFunctionInTable

ViridianCityScriptPointers:
	dw ViridianCityScript0
	dw ViridianCityScript1
	dw ViridianCityScript2
	dw ViridianCityScript3

ViridianCityScript0:
	call ViridianCityScript_1900b
	jp ViridianCityScript_1903d

ViridianCityScript_1900b:
	CheckEvent EVENT_VIRIDIAN_GYM_OPEN
	ret nz
	ld a, [wObtainedBadges]
	cp %01111111
	jr nz, .asm_1901e
	SetEvent EVENT_VIRIDIAN_GYM_OPEN
	ret
.asm_1901e
	ld a, [wYCoord]
	cp $8
	ret nz
	ld a, [wXCoord]
	cp $20
	ret nz
	ld a, $e
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [hJoyHeld], a
	call ViridianCityScript_190cf
	ld a, $3
	ld [wViridianCityCurScript], a
	ret

ViridianCityScript_1903d:
	CheckEvent EVENT_GOT_POKEDEX
	ret nz
	ld a, [wYCoord]
	cp $9
	ret nz
	ld a, [wXCoord]
	cp $13
	ret nz
	ld a, $5
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [hJoyHeld], a
	call ViridianCityScript_190cf
	ld a, $3
	ld [wViridianCityCurScript], a
	ret

ViridianCityScript1:
	ld a, [wSpriteStateData1 + $34]
	ld [$ffeb], a
	ld a, [wSpriteStateData1 + $36]
	ld [$ffec], a
	ld a, [wSpriteStateData2 + $34]
	ld [$ffed], a
	ld a, [wSpriteStateData2 + $35]
	ld [$ffee], a
	xor a
	ld [wListScrollOffset], a

	; set up battle for Old Man
	ld a, BATTLE_TYPE_OLD_MAN
	ld [wBattleType], a
	ld a, 5
	ld [wCurEnemyLVL], a
	ld a, WEEDLE
	ld [wCurOpponent], a
	ld a, $2
	ld [wViridianCityCurScript], a
	ret

ViridianCityScript2:
	ld a, [$ffeb]
	ld [wSpriteStateData1 + $34], a
	ld a, [$ffec]
	ld [wSpriteStateData1 + $36], a
	ld a, [$ffed]
	ld [wSpriteStateData2 + $34], a
	ld a, [$ffee]
	ld [wSpriteStateData2 + $35], a
	call UpdateSprites
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld a, $f
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wBattleType], a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wViridianCityCurScript], a
	ret

ViridianCityScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, 0
	ld [wViridianCityCurScript], a
	ret

ViridianCityScript_190cf:
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	xor a
	ld [wSpriteStateData1 + 9], a
	ld [wJoyIgnore], a
	ret

ViridianCityTextPointers:
	dw ViridianCityText1
	dw ViridianCityText2
	dw ViridianCityText3
	dw ViridianCityText4
	dw ViridianCityText5
	dw ViridianCityText6
	dw ViridianCityText7
	dw ViridianCityText8
	dw ViridianCityText9
	dw ViridianCityText10
	dw MartSignText
	dw PokeCenterSignText
	dw ViridianCityText13
	dw ViridianCityText14
	dw ViridianCityText15

ViridianCityText1:
	text ""
	fartext _ViridianCityText1
	done

ViridianCityText2:
	TX_ASM
	ld a, [wObtainedBadges]
	cp %01111111
	ld hl, ViridianCityText_19127
	jr z, .asm_ae9fe
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	jr nz, .asm_ae9fe
	ld hl, ViridianCityText_19122
.asm_ae9fe
	call PrintText
	jp TextScriptEnd

ViridianCityText_19122:
	text ""
	fartext _ViridianCityText_19122
	done

ViridianCityText_19127:
	text ""
	fartext _ViridianCityText_19127
	done

ViridianCityText3:
	TX_ASM
	ld hl, ViridianCityText_1914d
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_6dfea
	ld hl, ViridianCityText_19157
	call PrintText
	jr .asm_d611f
.asm_6dfea
	ld hl, ViridianCityText_19152
	call PrintText
.asm_d611f
	jp TextScriptEnd

ViridianCityText_1914d:
	text ""
	fartext _ViridianCityText_1914d
	done

ViridianCityText_19152:
	text ""
	fartext _ViridianCityText_19152
	done

ViridianCityText_19157:
	text ""
	fartext _ViridianCityText_19157
	done

ViridianCityText4:
	TX_ASM
	CheckEvent EVENT_GOT_POKEDEX
	jr nz, .asm_83894
	ld hl, ViridianCityText_19175
	call PrintText
	jr .asm_700a6
.asm_83894
	ld hl, ViridianCityText_1917a
	call PrintText
.asm_700a6
	jp TextScriptEnd

ViridianCityText_19175:
	text ""
	fartext _ViridianCityText_19175
	done

ViridianCityText_1917a:
	text ""
	fartext _ViridianCityText_1917a
	done

ViridianCityText5:
	TX_ASM
	ld hl, ViridianCityText_19191
	call PrintText
	call ViridianCityScript_190cf
	ld a, $3
	ld [wViridianCityCurScript], a
	jp TextScriptEnd

ViridianCityText_19191:
	text ""
	fartext _ViridianCityText_19191
	done

ViridianCityText6:
	TX_ASM
	CheckEvent EVENT_GOT_TM42
	jr nz, .asm_4e5a0
	ld hl, ViridianCityText_191ca
	call PrintText
	lb bc, TM_42, 1
	call GiveItem
	jr nc, .BagFull
	ld hl, ReceivedTM42Text
	call PrintText
	SetEvent EVENT_GOT_TM42
	jr .asm_3c73c
.BagFull
	ld hl, TM42NoRoomText
	call PrintText
	jr .asm_3c73c
.asm_4e5a0
	ld hl, TM42Explanation
	call PrintText
.asm_3c73c
	jp TextScriptEnd

ViridianCityText_191ca:
	text ""
	fartext _ViridianCityText_191ca
	done

ReceivedTM42Text:
	text ""
	fartext _ReceivedTM42Text
	sfxtext SFX_GET_ITEM_2
	done

TM42Explanation:
	text ""
	fartext _TM42Explanation
	done

TM42NoRoomText:
	text ""
	fartext _TM42NoRoomText
	done

ViridianCityText7:
	TX_ASM
	ld hl, ViridianCityText_1920a
	call PrintText
	ld c, 2
	call DelayFrames
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr z, .asm_42f68
	ld hl, ViridianCityText_1920f
	call PrintText
	ld a, $1
	ld [wViridianCityCurScript], a
	jr .asm_2413a
.asm_42f68
	ld hl, ViridianCityText_19214
	call PrintText
.asm_2413a
	jp TextScriptEnd

ViridianCityText_1920a:
	text ""
	fartext _ViridianCityText_1920a
	done

ViridianCityText_1920f:
	text ""
	fartext _ViridianCityText_1920f
	done

ViridianCityText_19214:
	text ""
	fartext _ViridianCityText_19214
	done

ViridianCityText15:
	text ""
	fartext _ViridianCityText_19219
	done

ViridianCityText8:
	text ""
	fartext _ViridianCityText8
	done

ViridianCityText9:
	text ""
	fartext _ViridianCityText9
	done

ViridianCityText10:
	text ""
	fartext _ViridianCityText10
	done

ViridianCityText13:
	text ""
	fartext _ViridianCityText13
	done

ViridianCityText14:
	text ""
	fartext _ViridianCityText14
	done
