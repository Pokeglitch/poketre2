VermilionCityScript:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	push hl
	call nz, VermilionCityScript_197cb
	pop hl
	bit 5, [hl]
	res 5, [hl]
	call nz, VermilionCityScript_197c0
	ld hl, VermilionCityScriptPointers
	ld a, [wVermilionCityCurScript]
	jp CallFunctionInTable

VermilionCityScript_197c0:
	call Random
	ld a, [$ffd4]
	and $e
	ld [wFirstLockTrashCanIndex], a
	ret

VermilionCityScript_197cb:
	CheckEventHL EVENT_SS_ANNE_LEFT
	ret z
	CheckEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	SetEventReuseHL EVENT_WALKED_PAST_GUARD_AFTER_SS_ANNE_LEFT
	ret nz
	ld a, $2
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScriptPointers:
	dw VermilionCityScript0
	dw VermilionCityScript1
	dw VermilionCityScript2
	dw VermilionCityScript3
	dw VermilionCityScript4

VermilionCityScript0:
	ld a, [wSpriteStateData1 + 9]
	and a ; cp SPRITE_FACING_DOWN
	ret nz
	ld hl, CoordsData_19823
	call ArePlayerCoordsInArray
	ret nc
	xor a
	ld [hJoyHeld], a
	ld [wcf0d], a
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .asm_19810
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ret nz
.asm_19810
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wVermilionCityCurScript], a
	ret

CoordsData_19823:
	db $1e,$12
	db $ff

VermilionCityScript4:
	ld hl, CoordsData_19823
	call ArePlayerCoordsInArray
	ret c
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript2:
	ld a, $ff
	ld [wJoyIgnore], a
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesEnd + 1], a
	ld a, 2
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld [hJoyHeld], a
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityScript1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld c, 10
	call DelayFrames
	ld a, $0
	ld [wVermilionCityCurScript], a
	ret

VermilionCityTextPointers:
	dw VermilionCityText1
	dw VermilionCityText2
	dw VermilionCityText3
	dw VermilionCityText4
	dw VermilionCityText5
	dw VermilionCityText6
	dw VermilionCityText7
	dw VermilionCityText8
	dw MartSignText
	dw PokeCenterSignText
	dw VermilionCityText11
	dw VermilionCityText12
	dw VermilionCityText13

VermilionCityText1:
	text ""
	fartext _VermilionCityText1
	done

VermilionCityText2:
	TX_ASM
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .asm_1989e
	ld hl, VermilionCityText_198a7
	call PrintText
	jr .asm_198a4
.asm_1989e
	ld hl, VermilionCityText_198ac
	call PrintText
.asm_198a4
	jp TextScriptEnd

VermilionCityText_198a7:
	text ""
	fartext _VermilionCityText_198a7
	done

VermilionCityText_198ac:
	text ""
	fartext _VermilionCityText_198ac
	done

VermilionCityText3:
	TX_ASM
	CheckEvent EVENT_SS_ANNE_LEFT
	jr nz, .asm_198f6
	ld a, [wSpriteStateData1 + 9]
	cp SPRITE_FACING_RIGHT
	jr z, .asm_198c8
	ld hl, VermilionCityCoords1
	call ArePlayerCoordsInArray
	jr nc, .asm_198d0
.asm_198c8
	ld hl, SSAnneWelcomeText4
	call PrintText
	jr .asm_198fc
.asm_198d0
	ld hl, SSAnneWelcomeText9
	call PrintText
	ld b, S_S_TICKET
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	jr nz, .asm_198e9
	ld hl, SSAnneNoTicketText
	call PrintText
	jr .asm_198fc
.asm_198e9
	ld hl, SSAnneFlashedTicketText
	call PrintText
	ld a, $4
	ld [wVermilionCityCurScript], a
	jr .asm_198fc
.asm_198f6
	ld hl, SSAnneNotHereText
	call PrintText
.asm_198fc
	jp TextScriptEnd

VermilionCityCoords1:
	db $1d,$13
	db $1f,$13
	db $ff

SSAnneWelcomeText4:
	text ""
	fartext _SSAnneWelcomeText4
	done

SSAnneWelcomeText9:
	text ""
	fartext _SSAnneWelcomeText9
	done

SSAnneFlashedTicketText:
	text ""
	fartext _SSAnneFlashedTicketText
	done

SSAnneNoTicketText:
	text ""
	fartext _SSAnneNoTicketText
	done

SSAnneNotHereText:
	text ""
	fartext _SSAnneNotHereText
	done

VermilionCityText4:
	text ""
	fartext _VermilionCityText4
	done

VermilionCityText5:
	text ""
	fartext _VermilionCityText5
	asmtext
	ld a, MACHOP
	call PlayCry
	call WaitForSoundToFinish
	ld hl, VermilionCityText14
	ret

VermilionCityText14:
	text ""
	fartext _VermilionCityText14
	done

VermilionCityText6:
	text ""
	fartext _VermilionCityText6
	done

VermilionCityText7:
	text ""
	fartext _VermilionCityText7
	done

VermilionCityText8:
	text ""
	fartext _VermilionCityText8
	done

VermilionCityText11:
	text ""
	fartext _VermilionCityText11
	done

VermilionCityText12:
	text ""
	fartext _VermilionCityText12
	done

VermilionCityText13:
	text ""
	fartext _VermilionCityText13
	done
