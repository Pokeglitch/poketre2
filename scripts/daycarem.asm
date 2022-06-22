DayCareMScript:
	jp EnableAutoTextBoxDrawing

DayCareMTextPointers:
	dw DayCareMText1

DAY_CARE_PRICE_PER_LEVEL EQU 100

DayCareMText1:
	asmtext
	call SaveScreenTilesToBuffer2
	ld a, [wDayCareInUse]
	and a
	jp nz, .daycareInUse
	ld hl, DayCareIntroText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	ld hl, DayCareComeAgainText
	jp nz, .done
	ld a, [wPartyCount]
	dec a
	ld hl, DayCareOnlyHaveOneMonText
	jp z, .done
	ld hl, DayCareWhichMonText
	call PrintText
	xor a
	ld [wUpdateSpritesEnabled], a
	ld [wPartyMenuTypeOrMessageID], a
	ld [wMenuItemToSwap], a
	call DisplayPartyMenu
	push af
	call GBPalWhiteOutWithDelay3
	call RestoreScreenTilesAndReloadTilePatterns
	call LoadGBPal
	pop af
	ld hl, DayCareAllRightThenText
	jp c, .done
	callab KnowsHMMove
	ld hl, DayCareCantAcceptMonWithHMText
	jp c, .done
	xor a
	ld [wPartyAndBillsPCSavedMenuItem], a
	ld a, [wWhichPokemon]
	ld hl, wPartyMonNicks
	call GetPartyMonName
	ld hl, DayCareWillLookAfterMonText
	call PrintText
	ld a, 1
	ld [wDayCareInUse], a
	ld a, PARTY_TO_DAYCARE
	ld [wMoveMonType], a
	call MoveMon
	xor a
	ld [wRemoveMonFromBox], a
	call RemovePokemon
	ld a, [wcf91]
	call PlayCry
	ld hl, DayCareComeSeeMeInAWhileText
	jp .done

.daycareInUse
	xor a
	ld hl, wDayCareMonName
	call GetPartyMonName
	ld a, DAYCARE_DATA
	ld [wMonDataLocation], a
	call LoadMonData
	callab CalcLevelFromExperience
	ld a, d
	cp MAX_LEVEL
	jr c, .skipCalcExp

	ld d, MAX_LEVEL
	callab CalcExperience
	ld hl, wDayCareMonExp
	ld a, [hExperience]
	ld [hli], a
	ld a, [hExperience + 1]
	ld [hli], a
	ld a, [hExperience + 2]
	ld [hl], a
	ld d, MAX_LEVEL

.skipCalcExp
	xor a
	ld [wDayCareNumLevelsGrown], a
	ld hl, wDayCareMonBoxLevel
	ld a, [hl]
	ld [wDayCareStartLevel], a
	cp d
	ld [hl], d
	ld hl, DayCareMonNeedsMoreTimeText
	jr z, .next
	ld a, [wDayCareStartLevel]
	ld b, a
	ld a, d
	sub b
	ld [wDayCareNumLevelsGrown], a
	ld hl, DayCareMonHasGrownText

.next
	call PrintText
	ld a, [wPartyCount]
	cp PARTY_LENGTH
	ld hl, DayCareNoRoomForMonText
	jp z, .leaveMonInDayCare
	ld de, wDayCareTotalCost
	xor a
	ld [de], a
	inc de
	ld [de], a
	ld hl, wDayCarePerLevelCost
	ld [hli], a
	ld [hl], DAY_CARE_PRICE_PER_LEVEL
	ld a, [wDayCareNumLevelsGrown]
	inc a
	ld b, a
	ld c, 2
.calcPriceLoop
	push hl
	push de
	push bc
	call AddBytes
	pop bc
	pop de
	pop hl
	dec b
	jr nz, .calcPriceLoop
	ld hl, DayCareOweMoneyText
	call PrintText
	call YesNoChoice
	ld hl, DayCareAllRightThenText
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .leaveMonInDayCare
	ld hl, wDayCareTotalCost
	ld [hMoney], a
	ld a, [hli]
	ld [hMoney + 1], a
	ld a, [hl]
	ld [hMoney + 2], a
	call HasEnoughMoney
	jr nc, .enoughMoney
	ld hl, DayCareNotEnoughMoneyText
	jp .leaveMonInDayCare

.enoughMoney
	xor a
	ld [wDayCareInUse], a
	ld hl, wDayCareTotalCost-1
	ld [hli], a
	inc hl
	ld de, wPlayerMoney + 2
	ld c, 3
	call SubtractBytes
	ld a, SFX_PURCHASE
	call PlaySoundWaitForCurrent
	ld hl, DayCareHeresYourMonText
	call PrintText
	ld a, DAYCARE_TO_PARTY
	ld [wMoveMonType], a
	call MoveMon
	ld a, [wDayCareMonSpecies]
	ld [wcf91], a
	ld a, [wPartyCount]
	dec a
	push af
	ld bc, wPartyMon2 - wPartyMon1
	push bc
	ld hl, wPartyMon1Moves
	call AddNTimes
	ld d, h
	ld e, l
	ld a, 1
	ld [wLearningMovesFromDayCare], a
	predef WriteMonMoves
	pop bc
	pop af

; set mon's HP to max
	ld hl, wPartyMon1HP
	call AddNTimes
	ld d, h
	ld e, l
	ld bc, wPartyMon1MaxHP - wPartyMon1HP
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a

	ld a, [wcf91]
	call PlayCry
	ld hl, DayCareGotMonBackText
	jr .done

.leaveMonInDayCare
	ld a, [wDayCareStartLevel]
	ld [wDayCareMonBoxLevel], a

.done
	call PrintText
	jp TextScriptEnd

DayCareIntroText:
	fartext _DayCareIntroText
	done

DayCareWhichMonText:
	fartext _DayCareWhichMonText
	done

DayCareWillLookAfterMonText:
	fartext _DayCareWillLookAfterMonText
	done

DayCareComeSeeMeInAWhileText:
	fartext _DayCareComeSeeMeInAWhileText
	done

DayCareMonHasGrownText:
	fartext _DayCareMonHasGrownText
	done

DayCareOweMoneyText:
	fartext _DayCareOweMoneyText
	done

DayCareGotMonBackText:
	fartext _DayCareGotMonBackText
	done

DayCareMonNeedsMoreTimeText:
	fartext _DayCareMonNeedsMoreTimeText
	done

DayCareAllRightThenText:
	fartext _DayCareAllRightThenText
DayCareComeAgainText:
	fartext _DayCareComeAgainText
	done

DayCareNoRoomForMonText:
	fartext _DayCareNoRoomForMonText
	done

DayCareOnlyHaveOneMonText:
	fartext _DayCareOnlyHaveOneMonText
	done

DayCareCantAcceptMonWithHMText:
	fartext _DayCareCantAcceptMonWithHMText
	done

DayCareHeresYourMonText:
	fartext _DayCareHeresYourMonText
	done

DayCareNotEnoughMoneyText:
	fartext _DayCareNotEnoughMoneyText
	done
