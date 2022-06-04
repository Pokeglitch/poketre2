CeladonGymScript:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, CeladonGymScript_48927
	call EnableAutoTextBoxDrawing
	ld hl, CeladonGymTrainerHeader0
	ld de, CeladonGymScriptPointers
	ld a, [wCeladonGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wCeladonGymCurScript], a
	ret

CeladonGymScript_48927:
	ld hl, Gym4CityName
	ld de, Gym4LeaderName
	jp LoadGymLeaderAndCityName

Gym4CityName:
	str "CELADON CITY"

Gym4LeaderName:
	str "ERIKA"

CeladonGymText_48943:
	xor a
	ld [wJoyIgnore], a
	ld [wCeladonGymCurScript], a
	ld [wCurMapScript], a
	ret

CeladonGymScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw CeladonGymScript3

CeladonGymScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CeladonGymText_48943
	ld a, $f0
	ld [wJoyIgnore], a

CeladonGymText_48963:
	ld a, $9
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_ERIKA
	lb bc, TM_21, 1
	call GiveItem
	jr nc, .BagFull
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM21
	jr .asm_4898c
.BagFull
	ld a, $b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.asm_4898c
	ld hl, wObtainedBadges
	set 3, [hl]
	ld hl, wBeatGymFlags
	set 3, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_CELADON_GYM_TRAINER_0, EVENT_BEAT_CELADON_GYM_TRAINER_6

	jp CeladonGymText_48943

CeladonGymTextPointers:
	dw CeladonGymText1
	dw CeladonGymText2
	dw CeladonGymText3
	dw CeladonGymText4
	dw CeladonGymText5
	dw CeladonGymText6
	dw CeladonGymText7
	dw CeladonGymText8
	dw CeladonGymText9
	dw TM21Text
	dw TM21NoRoomText

CeladonGymTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_0
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_0
	dw CeladonGymBattleText2 ; TextBeforeBattle
	dw CeladonGymAfterBattleText2 ; TextAfterBattle
	dw CeladonGymEndBattleText2 ; TextEndBattle
	dw CeladonGymEndBattleText2 ; TextEndBattle

CeladonGymTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_1
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_1
	dw CeladonGymBattleText3 ; TextBeforeBattle
	dw CeladonGymAfterBattleText3 ; TextAfterBattle
	dw CeladonGymEndBattleText3 ; TextEndBattle
	dw CeladonGymEndBattleText3 ; TextEndBattle

CeladonGymTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_2
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_2
	dw CeladonGymBattleText4 ; TextBeforeBattle
	dw CeladonGymAfterBattleText4 ; TextAfterBattle
	dw CeladonGymEndBattleText4 ; TextEndBattle
	dw CeladonGymEndBattleText4 ; TextEndBattle

CeladonGymTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_3
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_3
	dw CeladonGymBattleText5 ; TextBeforeBattle
	dw CeladonGymAfterBattleText5 ; TextAfterBattle
	dw CeladonGymEndBattleText5 ; TextEndBattle
	dw CeladonGymEndBattleText5 ; TextEndBattle

CeladonGymTrainerHeader4:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_4
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_4
	dw CeladonGymBattleText6 ; TextBeforeBattle
	dw CeladonGymAfterBattleText6 ; TextAfterBattle
	dw CeladonGymEndBattleText6 ; TextEndBattle
	dw CeladonGymEndBattleText6 ; TextEndBattle

CeladonGymTrainerHeader5:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_5
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_5
	dw CeladonGymBattleText7 ; TextBeforeBattle
	dw CeladonGymAfterBattleText7 ; TextAfterBattle
	dw CeladonGymEndBattleText7 ; TextEndBattle
	dw CeladonGymEndBattleText7 ; TextEndBattle

CeladonGymTrainerHeader6:
	dbEventFlagBit EVENT_BEAT_CELADON_GYM_TRAINER_6, 1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_CELADON_GYM_TRAINER_6, 1
	dw CeladonGymBattleText8 ; TextBeforeBattle
	dw CeladonGymAfterBattleText8 ; TextAfterBattle
	dw CeladonGymEndBattleText8 ; TextEndBattle
	dw CeladonGymEndBattleText8 ; TextEndBattle

	db $ff

CeladonGymText1:
	asmtext
	CheckEvent EVENT_BEAT_ERIKA
	jr z, .asm_48a2d
	CheckEventReuseA EVENT_GOT_TM21
	jr nz, .asm_48a25
	call z, CeladonGymText_48963
	call DisableWaitingAfterTextDisplay
	jr .asm_48a5b
.asm_48a25
	ld hl, CeladonGymText_48a68
	call PrintText
	jr .asm_48a5b
.asm_48a2d
	ld hl, CeladonGymText_48a5e
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, CeladonGymText_48a63
	ld de, CeladonGymText_48a63
	call SaveEndBattleTextPointers
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $4
	ld [wGymLeaderNo], a
	ld a, $3
	ld [wCeladonGymCurScript], a
	ld [wCurMapScript], a
.asm_48a5b
	jp TextScriptEnd

CeladonGymText_48a5e:
	fartext _CeladonGymText_48a5e
	done

CeladonGymText_48a63:
	fartext _CeladonGymText_48a63
	done

CeladonGymText_48a68:
	fartext _CeladonGymText_48a68
	done

CeladonGymText9:
	fartext _CeladonGymText9
	done

TM21Text:
	fartext _ReceivedTM21Text
	sfxtext SFX_GET_ITEM_1
	fartext _TM21ExplanationText
	done

TM21NoRoomText:
	fartext _TM21NoRoomText
	done

CeladonGymText2:
	asmtext
	ld hl, CeladonGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText2:
	fartext _CeladonGymBattleText2
	done

CeladonGymEndBattleText2:
	fartext _CeladonGymEndBattleText2
	done

CeladonGymAfterBattleText2:
	fartext _CeladonGymAfterBattleText2
	done

CeladonGymText3:
	asmtext
	ld hl, CeladonGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText3:
	fartext _CeladonGymBattleText3
	done

CeladonGymEndBattleText3:
	fartext _CeladonGymEndBattleText3
	done

CeladonGymAfterBattleText3:
	fartext _CeladonGymAfterBattleText3
	done

CeladonGymText4:
	asmtext
	ld hl, CeladonGymTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText4:
	fartext _CeladonGymBattleText4
	done

CeladonGymEndBattleText4:
	fartext _CeladonGymEndBattleText4
	done

CeladonGymAfterBattleText4:
	fartext _CeladonGymAfterBattleText4
	done

CeladonGymText5:
	asmtext
	ld hl, CeladonGymTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText5:
	fartext _CeladonGymBattleText5
	done

CeladonGymEndBattleText5:
	fartext _CeladonGymEndBattleText5
	done

CeladonGymAfterBattleText5:
	fartext _CeladonGymAfterBattleText5
	done

CeladonGymText6:
	asmtext
	ld hl, CeladonGymTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText6:
	fartext _CeladonGymBattleText6
	done

CeladonGymEndBattleText6:
	fartext _CeladonGymEndBattleText6
	done

CeladonGymAfterBattleText6:
	fartext _CeladonGymAfterBattleText6
	done

CeladonGymText7:
	asmtext
	ld hl, CeladonGymTrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText7:
	fartext _CeladonGymBattleText7
	done

CeladonGymEndBattleText7:
	fartext _CeladonGymEndBattleText7
	done

CeladonGymAfterBattleText7:
	fartext _CeladonGymAfterBattleText7
	done

CeladonGymText8:
	asmtext
	ld hl, CeladonGymTrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

CeladonGymBattleText8:
	fartext _CeladonGymBattleText8
	done

CeladonGymEndBattleText8:
	fartext _CeladonGymEndBattleText8
	done

CeladonGymAfterBattleText8:
	fartext _CeladonGymAfterBattleText8
	done
