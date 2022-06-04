PewterGymScript:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, PewterGymScript_5c3a4
	call EnableAutoTextBoxDrawing
	ld hl, PewterGymTrainerHeader0
	ld de, PewterGymScriptPointers
	ld a, [wPewterGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPewterGymCurScript], a
	ret

PewterGymScript_5c3a4:
	ld hl, Gym1CityName
	ld de, Gym1LeaderName
	jp LoadGymLeaderAndCityName

Gym1CityName:
	db "PEWTER CITY@"

Gym1LeaderName:
	db "BROCK@"

PewterGymScript_5c3bf:
	xor a
	ld [wJoyIgnore], a
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
	ret

PewterGymScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw PewterGymScript3

PewterGymScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PewterGymScript_5c3bf
	ld a, $f0
	ld [wJoyIgnore], a

PewterGymScript_5c3df:
	ld a, $4
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_BROCK
	lb bc, TM_34, 1
	call GiveItem
	jr nc, .BagFull
	ld a, $5
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM34
	jr .asm_5c408
.BagFull
	ld a, $6
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.asm_5c408
	ld hl, wObtainedBadges
	set 0, [hl]
	ld hl, wBeatGymFlags
	set 0, [hl]

	ld a, HS_GYM_GUY
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wMissableObjectIndex], a
	predef HideObject

	ResetEvents EVENT_1ST_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE

	; deactivate gym trainers
	SetEvent EVENT_BEAT_PEWTER_GYM_TRAINER_0

	jp PewterGymScript_5c3bf

PewterGymTextPointers:
	dw PewterGymText1
	dw PewterGymText2
	dw PewterGymText3
	dw PewterGymText4
	dw PewterGymText5
	dw PewterGymText6

PewterGymTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_PEWTER_GYM_TRAINER_0
	db ($5 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_PEWTER_GYM_TRAINER_0
	dw PewterGymBattleText1 ; TextBeforeBattle
	dw PewterGymAfterBattleText1 ; TextAfterBattle
	dw PewterGymEndBattleText1 ; TextEndBattle
	dw PewterGymEndBattleText1 ; TextEndBattle

	db $ff

PewterGymText1:
	text ""
	asmtext
	CheckEvent EVENT_BEAT_BROCK
	jr z, .asm_5c46a
	CheckEventReuseA EVENT_GOT_TM34
	jr nz, .asm_5c462
	call z, PewterGymScript_5c3df
	call DisableWaitingAfterTextDisplay
	jr .asm_5c49b
.asm_5c462
	ld hl, PewterGymText_5c4a3
	call PrintText
	jr .asm_5c49b
.asm_5c46a
	ld hl, PewterGymText_5c49e
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, PewterGymText_5c4bc
	ld de, PewterGymText_5c4bc
	call SaveEndBattleTextPointers
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $1
	ld [wGymLeaderNo], a
	xor a
	ld [hJoyHeld], a
	ld a, $3
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
.asm_5c49b
	jp TextScriptEnd

PewterGymText_5c49e:
	text ""
	fartext _PewterGymText_5c49e
	done

PewterGymText_5c4a3:
	text ""
	fartext _PewterGymText_5c4a3
	done

PewterGymText4:
	text ""
	fartext _TM34PreReceiveText
	done

PewterGymText5:
	text ""
	fartext _ReceivedTM34Text
	sfxtext SFX_GET_ITEM_1
	fartext _TM34ExplanationText
	done

PewterGymText6:
	text ""
	fartext _TM34NoRoomText
	done

PewterGymText_5c4bc:
	text ""
	fartext _PewterGymText_5c4bc
	sfxtext SFX_GET_ITEM_1 ; plays SFX_LEVEL_UP instead since the wrong music bank is loaded
	fartext _PewterGymText_5c4c1
	done

PewterGymText2:
	text ""
	asmtext
	ld hl, PewterGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PewterGymBattleText1:
	text ""
	fartext _PewterGymBattleText1
	done

PewterGymEndBattleText1:
	text ""
	fartext _PewterGymEndBattleText1
	done

PewterGymAfterBattleText1:
	text ""
	fartext _PewterGymAfterBattleText1
	done

PewterGymText3:
	text ""
	asmtext
	ld a, [wBeatGymFlags]
	bit 0, a
	jr nz, .asm_5c50c
	ld hl, PewterGymText_5c515
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_5c4fe
	ld hl, PewterGymText_5c51a
	call PrintText
	jr .asm_5c504
.asm_5c4fe
	ld hl, PewterGymText_5c524
	call PrintText
.asm_5c504
	ld hl, PewterGymText_5c51f
	call PrintText
	jr .asm_5c512
.asm_5c50c
	ld hl, PewterGymText_5c529
	call PrintText
.asm_5c512
	jp TextScriptEnd

PewterGymText_5c515:
	text ""
	fartext _PewterGymText_5c515
	done

PewterGymText_5c51a:
	text ""
	fartext _PewterGymText_5c51a
	done

PewterGymText_5c51f:
	text ""
	fartext _PewterGymText_5c51f
	done

PewterGymText_5c524:
	text ""
	fartext _PewterGymText_5c524
	done

PewterGymText_5c529:
	text ""
	fartext _PewterGymText_5c529
	done
