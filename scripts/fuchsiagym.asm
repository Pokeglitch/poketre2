FuchsiaGymScript:
	call FuchsiaGymScript_75453
	call EnableAutoTextBoxDrawing
	ld hl, FuchsiaGymTrainerHeader0
	ld de, FuchsiaGymScriptPointers
	ld a, [wFuchsiaGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wFuchsiaGymCurScript], a
	ret

FuchsiaGymScript_75453:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	ret z
	ld hl, Gym5CityName
	ld de, Gym5LeaderName
	call LoadGymLeaderAndCityName
	ret

Gym5CityName:
	str "FUCHSIA CITY"
Gym5LeaderName:
	str "KOGA"

FuchsiaGymScript_75477:
	xor a
	ld [wJoyIgnore], a
	ld [wFuchsiaGymCurScript], a
	ld [wCurMapScript], a
	ret

FuchsiaGymScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw FuchsiaGymScript3

FuchsiaGymScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, FuchsiaGymScript_75477
	ld a, $f0
	ld [wJoyIgnore], a
FuchsiaGymScript3_75497:
	ld a, $9
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_KOGA
	lb bc, TM_06, 1
	call GiveItem
	jr nc, .BagFull
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM06
	jr .asm_754c0
.BagFull
	ld a, $b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.asm_754c0
	ld hl, wObtainedBadges
	set 4, [hl]
	ld hl, wBeatGymFlags
	set 4, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_FUCHSIA_GYM_TRAINER_0, EVENT_BEAT_FUCHSIA_GYM_TRAINER_5

	jp FuchsiaGymScript_75477

FuchsiaGymTextPointers:
	dw FuchsiaGymText1
	dw FuchsiaGymText2
	dw FuchsiaGymText3
	dw FuchsiaGymText4
	dw FuchsiaGymText5
	dw FuchsiaGymText6
	dw FuchsiaGymText7
	dw FuchsiaGymText8
	dw FuchsiaGymText9
	dw FuchsiaGymText10
	dw FuchsiaGymText11

FuchsiaGymTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_FUCHSIA_GYM_TRAINER_0
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FUCHSIA_GYM_TRAINER_0
	dw FuchsiaGymBattleText1 ; TextBeforeBattle
	dw FuchsiaGymAfterBattleText1 ; TextAfterBattle
	dw FuchsiaGymEndBattleText1 ; TextEndBattle
	dw FuchsiaGymEndBattleText1 ; TextEndBattle

FuchsiaGymTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_FUCHSIA_GYM_TRAINER_1
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FUCHSIA_GYM_TRAINER_1
	dw FuchsiaGymBattleText2 ; TextBeforeBattle
	dw FuchsiaGymAfterBattleText2 ; TextAfterBattle
	dw FuchsiaGymEndBattleText2 ; TextEndBattle
	dw FuchsiaGymEndBattleText2 ; TextEndBattle

FuchsiaGymTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_FUCHSIA_GYM_TRAINER_2
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FUCHSIA_GYM_TRAINER_2
	dw FuchsiaGymBattleText3 ; TextBeforeBattle
	dw FuchsiaGymAfterBattleText3 ; TextAfterBattle
	dw FuchsiaGymEndBattleText3 ; TextEndBattle
	dw FuchsiaGymEndBattleText3 ; TextEndBattle

FuchsiaGymTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_FUCHSIA_GYM_TRAINER_3
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FUCHSIA_GYM_TRAINER_3
	dw FuchsiaGymBattleText4 ; TextBeforeBattle
	dw FuchsiaGymAfterBattleText4 ; TextAfterBattle
	dw FuchsiaGymEndBattleText4 ; TextEndBattle
	dw FuchsiaGymEndBattleText4 ; TextEndBattle

FuchsiaGymTrainerHeader4:
	dbEventFlagBit EVENT_BEAT_FUCHSIA_GYM_TRAINER_4
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FUCHSIA_GYM_TRAINER_4
	dw FuchsiaGymBattleText5 ; TextBeforeBattle
	dw FuchsiaGymAfterBattleText5 ; TextAfterBattle
	dw FuchsiaGymEndBattleText5 ; TextEndBattle
	dw FuchsiaGymEndBattleText5 ; TextEndBattle

FuchsiaGymTrainerHeader5:
	dbEventFlagBit EVENT_BEAT_FUCHSIA_GYM_TRAINER_5
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FUCHSIA_GYM_TRAINER_5
	dw FuchsiaGymBattleText6 ; TextBeforeBattle
	dw FuchsiaGymAfterBattleText6 ; TextAfterBattle
	dw FuchsiaGymEndBattleText6 ; TextEndBattle
	dw FuchsiaGymEndBattleText6 ; TextEndBattle

	db $ff

FuchsiaGymText1:
	text ""
	asmtext
	CheckEvent EVENT_BEAT_KOGA
	jr z, .asm_181b6
	CheckEventReuseA EVENT_GOT_TM06
	jr nz, .asm_adc3b
	call z, FuchsiaGymScript3_75497
	call DisableWaitingAfterTextDisplay
	jr .asm_e84c6
.asm_adc3b
	ld hl, KogaExplainToxicText
	call PrintText
	jr .asm_e84c6
.asm_181b6
	ld hl, KogaBeforeBattleText
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, KogaAfterBattleText
	ld de, KogaAfterBattleText
	call SaveEndBattleTextPointers
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $5
	ld [wGymLeaderNo], a
	xor a
	ld [hJoyHeld], a
	ld a, $3
	ld [wFuchsiaGymCurScript], a
.asm_e84c6
	jp TextScriptEnd

KogaBeforeBattleText:
	text ""
	fartext _KogaBeforeBattleText
	done

KogaAfterBattleText:
	text ""
	fartext _KogaAfterBattleText
	done

KogaExplainToxicText:
	text ""
	fartext _KogaExplainToxicText
	done

FuchsiaGymText9:
	text ""
	fartext _FuchsiaGymText9
	done

FuchsiaGymText10:
	text ""
	fartext _ReceivedTM06Text
	sfxtext SFX_GET_KEY_ITEM

TM06ExplanationText:
	text ""
	fartext _TM06ExplanationText
	done

FuchsiaGymText11:
	text ""
	fartext _TM06NoRoomText
	done

FuchsiaGymText2:
	text ""
	asmtext
	ld hl, FuchsiaGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymBattleText1:
	text ""
	fartext _FuchsiaGymBattleText1
	done

FuchsiaGymEndBattleText1:
	text ""
	fartext _FuchsiaGymEndBattleText1
	done

FuchsiaGymAfterBattleText1:
	text ""
	fartext _FuchsiaGymAfterBattleText1
	done

FuchsiaGymText3:
	text ""
	asmtext
	ld hl, FuchsiaGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymBattleText2:
	text ""
	fartext _FuchsiaGymBattleText2
	done

FuchsiaGymEndBattleText2:
	text ""
	fartext _FuchsiaGymEndBattleText2
	done

FuchsiaGymAfterBattleText2:
	text ""
	fartext _FuchsiaGymAfterBattleText2
	done

FuchsiaGymText4:
	text ""
	asmtext
	ld hl, FuchsiaGymTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymBattleText3:
	text ""
	fartext _FuchsiaGymBattleText3
	done

FuchsiaGymEndBattleText3:
	text ""
	fartext _FuchsiaGymEndBattleText3
	done

FuchsiaGymAfterBattleText3:
	text ""
	fartext _FuchsiaGymAfterBattleText3
	done

FuchsiaGymText5:
	text ""
	asmtext
	ld hl, FuchsiaGymTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymBattleText4:
	text ""
	fartext _FuchsiaGymBattleText4
	done

FuchsiaGymEndBattleText4:
	text ""
	fartext _FuchsiaGymEndBattleText4
	done

FuchsiaGymAfterBattleText4:
	text ""
	fartext _FuchsiaGymAfterBattleText4
	done

FuchsiaGymText6:
	text ""
	asmtext
	ld hl, FuchsiaGymTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymBattleText5:
	text ""
	fartext _FuchsiaGymBattleText5
	done

FuchsiaGymEndBattleText5:
	text ""
	fartext _FuchsiaGymEndBattleText5
	done

FuchsiaGymAfterBattleText5:
	text ""
	fartext _FuchsiaGymAfterBattleText5
	done

FuchsiaGymText7:
	text ""
	asmtext
	ld hl, FuchsiaGymTrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

FuchsiaGymBattleText6:
	text ""
	fartext _FuchsiaGymBattleText6
	done

FuchsiaGymEndBattleText6:
	text ""
	fartext _FuchsiaGymEndBattleText6
	done

FuchsiaGymAfterBattleText6:
	text ""
	fartext _FuchsiaGymAfterBattleText6
	done

FuchsiaGymText8:
	text ""
	asmtext
	CheckEvent EVENT_BEAT_KOGA
	ld hl, FuchsiaGymText_75653
	jr nz, .asm_50671
	ld hl, FuchsiaGymText_7564e
.asm_50671
	call PrintText
	jp TextScriptEnd

FuchsiaGymText_7564e:
	text ""
	fartext _FuchsiaGymText_7564e
	done

FuchsiaGymText_75653:
	text ""
	fartext _FuchsiaGymText_75653
	done
