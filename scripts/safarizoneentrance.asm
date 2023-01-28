SafariZoneEntranceScript:
	call EnableAutoTextBoxDrawing
	ld hl, SafariZoneEntranceScriptPointers
	ld a, [wSafariZoneEntranceCurScript]
	jp CallFunctionInTable

SafariZoneEntranceScriptPointers:
	dw .SafariZoneEntranceScript0
	dw .SafariZoneEntranceScript1
	dw .SafariZoneEntranceScript2
	dw .SafariZoneEntranceScript3
	dw .SafariZoneEntranceScript4
	dw .SafariZoneEntranceScript5
	dw .SafariZoneEntranceScript6

.SafariZoneEntranceScript0
	ld hl, .CoordsData_75221
	call ArePlayerCoordsInArray
	ret nc
	ld a, $3
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a
	xor a
	ld [hJoyHeld], a
	ld a, SPRITE_FACING_RIGHT
	ld [wSpriteStateData1 + 9], a
	ld a, [wCoordIndex]
	cp $1
	jr z, .asm_7520f
	ld a, $2
	ld [wSafariZoneEntranceCurScript], a
	ret
.asm_7520f
	ld a, D_RIGHT
	ld c, $1
	call SafariZoneEntranceAutoWalk
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $1
	ld [wSafariZoneEntranceCurScript], a
	ret

.CoordsData_75221:
	db $02,$03
	db $02,$04
	db $FF

.SafariZoneEntranceScript1
	call SafariZoneEntranceScript_752b4
	ret nz
.SafariZoneEntranceScript2
	xor a
	ld [hJoyHeld], a
	ld [wJoyIgnore], a
	call UpdateSprites
	ld a, $4
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a
	ret

.SafariZoneEntranceScript3
	call SafariZoneEntranceScript_752b4
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, $5
	ld [wSafariZoneEntranceCurScript], a
	ret

.SafariZoneEntranceScript5
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	CheckAndResetEvent EVENT_SAFARI_GAME_OVER
	jr z, .asm_7527f
	ResetEventReuseHL EVENT_IN_SAFARI_ZONE
	call UpdateSprites
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $6
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wNumSafariBalls], a
	ld a, D_DOWN
	ld c, $3
	call SafariZoneEntranceAutoWalk
	ld a, $4
	ld [wSafariZoneEntranceCurScript], a
	jr .asm_75286
.asm_7527f
	ld a, $5
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.asm_75286
	ret

.SafariZoneEntranceScript4
	call SafariZoneEntranceScript_752b4
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wSafariZoneEntranceCurScript], a
	ret

.SafariZoneEntranceScript6
	call SafariZoneEntranceScript_752b4
	ret nz
	call Delay3
	ld a, [wcf0d]
	ld [wSafariZoneEntranceCurScript], a
	ret

SafariZoneEntranceAutoWalk:
	push af
	ld b, 0
	ld a, c
	ld [wSimulatedJoypadStatesIndex], a
	ld hl, wSimulatedJoypadStatesEnd
	pop af
	call FillMemory
	jp StartSimulatingJoypadStates

SafariZoneEntranceScript_752b4:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret

SAFARI_ZONE_TICKET_PRICE EQU 500

SafariZoneEntranceTrainerHeader0:
	db TrainerHeaderTerminator

SafariZoneEntranceTextPointers:
	dw .SafariZoneEntranceText1
	dw .SafariZoneEntranceText2
	dw .SafariZoneEntranceText1
	dw .SafariZoneEntranceText4
	dw .SafariZoneEntranceText5
	dw .SafariZoneEntranceText6

.SafariZoneEntranceText1
	fartext _SafariZoneEntranceText1
	done

.SafariZoneEntranceText4
	fartext SafariZoneEntranceText_9e6e4
	asmtext
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .PleaseComeAgain
	xor a
	ld [hMoney], a
	ld a, SAFARI_ZONE_TICKET_PRICE / $100
	ld [hMoney + 1], a
	ld a, SAFARI_ZONE_TICKET_PRICE & $FF
	ld [hMoney + 2], a
	call HasEnoughMoney
	jr nc, .success
	ld hl, .NotEnoughMoneyText
	call PrintText
	jr .CantPayWalkDown

.success
	xor a
	ld [wPriceTemp], a
	ld a, SAFARI_ZONE_TICKET_PRICE / $100
	ld [wPriceTemp + 1], a
	ld a, SAFARI_ZONE_TICKET_PRICE & $FF
	ld [wPriceTemp + 2], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, 3
	call SubtractBytes
	ld hl, .MakePaymentText
	call PrintText
	ld a, 30
	ld [wNumSafariBalls], a
	ld a, 502 / $100
	ld [wSafariSteps], a
	ld a, 502 % $100
	ld [wSafariSteps + 1], a
	ld a, D_UP
	ld c, 3
	call SafariZoneEntranceAutoWalk
	SetEvent EVENT_IN_SAFARI_ZONE
	ResetEventReuseHL EVENT_SAFARI_GAME_OVER
	ld a, 3
	ld [wSafariZoneEntranceCurScript], a
	jr .done

.PleaseComeAgain
	ld hl, .PleaseComeAgainText
	call PrintText
.CantPayWalkDown
	ld a, D_DOWN
	ld c, 1
	call SafariZoneEntranceAutoWalk
	ld a, 4
	ld [wSafariZoneEntranceCurScript], a
.done
	jp TextScriptEnd

.MakePaymentText
	fartext SafariZoneEntranceText_9e747
	sfxtext SFX_GET_ITEM_1
	fartext _SafariZoneEntranceText_75360
	done

.PleaseComeAgainText
	fartext _SafariZoneEntranceText_75365
	done

.NotEnoughMoneyText
	fartext _SafariZoneEntranceText_7536a
	done

.SafariZoneEntranceText5
	fartext SafariZoneEntranceText_9e814
	asmtext
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_7539c
	ld hl, .SafariZoneEntranceText_753bb
	call PrintText
	xor a
	ld [wSpriteStateData1 + 9], a
	ld a, D_DOWN
	ld c, $3
	call SafariZoneEntranceAutoWalk
	ResetEvents EVENT_SAFARI_GAME_OVER, EVENT_IN_SAFARI_ZONE
	ld a, $0
	ld [wcf0d], a
	jr .asm_753b3
.asm_7539c
	ld hl, .SafariZoneEntranceText_753c0
	call PrintText
	ld a, SPRITE_FACING_UP
	ld [wSpriteStateData1 + 9], a
	ld a, D_UP
	ld c, $1
	call SafariZoneEntranceAutoWalk
	ld a, $5
	ld [wcf0d], a
.asm_753b3
	ld a, $6
	ld [wSafariZoneEntranceCurScript], a
	jp TextScriptEnd

.SafariZoneEntranceText_753bb
	fartext _SafariZoneEntranceText_753bb
	done

.SafariZoneEntranceText_753c0
	fartext _SafariZoneEntranceText_753c0
	done

.SafariZoneEntranceText6
	fartext _SafariZoneEntranceText_753c5
	done

.SafariZoneEntranceText2
	asmtext
	ld hl, .FirstTimeQuestionText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, .RegularText
	jr nz, .Explanation
	ld hl, .ExplanationText
.Explanation
	call PrintText
	jp TextScriptEnd

.FirstTimeQuestionText
	fartext _SafariZoneEntranceText_753e6
	done

.ExplanationText
	fartext _SafariZoneEntranceText_753eb
	done

.RegularText
	fartext _SafariZoneEntranceText_753f0
	done
