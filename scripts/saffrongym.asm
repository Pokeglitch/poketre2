SaffronGymScript:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, .extra
	call EnableAutoTextBoxDrawing
	ld hl, SaffronGymTrainerHeader0
	ld de, SaffronGymScriptPointers
	ld a, [wSaffronGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wSaffronGymCurScript], a
	ret

.extra
	ld hl, Gym6CityName
	ld de, Gym6LeaderName
	jp LoadGymLeaderAndCityName

Gym6CityName:
	str "SAFFRON CITY"

Gym6LeaderName:
	str "SABRINA"

SaffronGymText_5d048:
	xor a
	ld [wJoyIgnore], a
	ld [wSaffronGymCurScript], a
	ld [wCurMapScript], a
	ret

SaffronGymScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw SaffronGymScript3

SaffronGymScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, SaffronGymText_5d048
	ld a, $f0
	ld [wJoyIgnore], a

SaffronGymText_5d068:
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_SABRINA
	lb bc, TM_46, 1
	call GiveItem
	jr nc, .BagFull
	ld a, $b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM46
	jr .asm_5d091
.BagFull
	ld a, $c
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.asm_5d091
	ld hl, wObtainedBadges
	set 5, [hl]
	ld hl, wBeatGymFlags
	set 5, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_SAFFRON_GYM_TRAINER_0, EVENT_BEAT_SAFFRON_GYM_TRAINER_6

	jp SaffronGymText_5d048

SaffronGymTextPointers:
	dw SaffronGymText1
	dw SaffronGymText2
	dw SaffronGymText3
	dw SaffronGymText4
	dw SaffronGymText5
	dw SaffronGymText6
	dw SaffronGymText7
	dw SaffronGymText8
	dw SaffronGymText9
	dw SaffronGymText10
	dw SaffronGymText11
	dw SaffronGymText12

SaffronGymTrainerHeader0:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SaffronGymBattleText1 ; TextBeforeBattle
	dw SaffronGymAfterBattleText1 ; TextAfterBattle
	dw SaffronGymEndBattleText1 ; TextEndBattle
	dw SaffronGymEndBattleText1 ; TextEndBattle

SaffronGymTrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SaffronGymBattleText2 ; TextBeforeBattle
	dw SaffronGymAfterBattleText2 ; TextAfterBattle
	dw SaffronGymEndBattleText2 ; TextEndBattle
	dw SaffronGymEndBattleText2 ; TextEndBattle

SaffronGymTrainerHeader2:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SaffronGymBattleText3 ; TextBeforeBattle
	dw SaffronGymAfterBattleText3 ; TextAfterBattle
	dw SaffronGymEndBattleText3 ; TextEndBattle
	dw SaffronGymEndBattleText3 ; TextEndBattle

SaffronGymTrainerHeader3:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SaffronGymBattleText4 ; TextBeforeBattle
	dw SaffronGymAfterBattleText4 ; TextAfterBattle
	dw SaffronGymEndBattleText4 ; TextEndBattle
	dw SaffronGymEndBattleText4 ; TextEndBattle

SaffronGymTrainerHeader4:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SaffronGymBattleText5 ; TextBeforeBattle
	dw SaffronGymAfterBattleText5 ; TextAfterBattle
	dw SaffronGymEndBattleText5 ; TextEndBattle
	dw SaffronGymEndBattleText5 ; TextEndBattle

SaffronGymTrainerHeader5:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SaffronGymBattleText6 ; TextBeforeBattle
	dw SaffronGymAfterBattleText6 ; TextAfterBattle
	dw SaffronGymEndBattleText6 ; TextEndBattle
	dw SaffronGymEndBattleText6 ; TextEndBattle

SaffronGymTrainerHeader6:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SaffronGymBattleText7 ; TextBeforeBattle
	dw SaffronGymAfterBattleText7 ; TextAfterBattle
	dw SaffronGymEndBattleText7 ; TextEndBattle
	dw SaffronGymEndBattleText7 ; TextEndBattle

	db $ff

SaffronGymText1:
	asmtext
	CheckEvent EVENT_BEAT_SABRINA
	jr z, .asm_5d134
	CheckEventReuseA EVENT_GOT_TM46
	jr nz, .asm_5d12c
	call z, SaffronGymText_5d068
	call DisableWaitingAfterTextDisplay
	jr .asm_5d15f
.asm_5d12c
	ld hl, SaffronGymText_5d16e
	call PrintText
	jr .asm_5d15f
.asm_5d134
	ld hl, SaffronGymText_5d162
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, SaffronGymText_5d167
	ld de, SaffronGymText_5d167
	call SaveEndBattleTextPointers
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	ld a, $6
	ld [wGymLeaderNo], a
	ld a, $3
	ld [wSaffronGymCurScript], a
.asm_5d15f
	jp TextScriptEnd

SaffronGymText_5d162:
	fartext _SaffronGymText_5d162
	done

SaffronGymText_5d167:
	fartext _SaffronGymText_5d167
	sfxtext SFX_GET_KEY_ITEM ; actually plays the second channel of SFX_BALL_POOF due to the wrong music bank being loaded
	wait
	done

SaffronGymText_5d16e:
	fartext _SaffronGymText_5d16e
	done

SaffronGymText10:
	fartext _SaffronGymText_5d173
	done

SaffronGymText11:
	fartext ReceivedTM46Text
	sfxtext SFX_GET_ITEM_1
	fartext _TM46ExplanationText
	done

SaffronGymText12:
	fartext _TM46NoRoomText
	done

SaffronGymText2:
	asmtext
	ld hl, SaffronGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText3:
	asmtext
	ld hl, SaffronGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText4:
	asmtext
	ld hl, SaffronGymTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText5:
	asmtext
	ld hl, SaffronGymTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText6:
	asmtext
	ld hl, SaffronGymTrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText7:
	asmtext
	ld hl, SaffronGymTrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText8:
	asmtext
	ld hl, SaffronGymTrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

SaffronGymText9:
	asmtext
	CheckEvent EVENT_BEAT_SABRINA
	jr nz, .asm_5d1dd
	ld hl, SaffronGymText_5d1e6
	call PrintText
	jr .asm_5d1e3
.asm_5d1dd
	ld hl, SaffronGymText_5d1eb
	call PrintText
.asm_5d1e3
	jp TextScriptEnd

SaffronGymText_5d1e6:
	fartext _SaffronGymText_5d1e6
	done

SaffronGymText_5d1eb:
	fartext _SaffronGymText_5d1eb
	done

SaffronGymBattleText1:
	fartext _SaffronGymBattleText1
	done

SaffronGymEndBattleText1:
	fartext _SaffronGymEndBattleText1
	done

SaffronGymAfterBattleText1:
	fartext _SaffronGymAfterBattleText1
	done

SaffronGymBattleText2:
	fartext _SaffronGymBattleText2
	done

SaffronGymEndBattleText2:
	fartext _SaffronGymEndBattleText2
	done

SaffronGymAfterBattleText2:
	fartext _SaffronGymAfterBattleText2
	done

SaffronGymBattleText3:
	fartext _SaffronGymBattleText3
	done

SaffronGymEndBattleText3:
	fartext _SaffronGymEndBattleText3
	done

SaffronGymAfterBattleText3:
	fartext _SaffronGymAfterBattleText3
	done

SaffronGymBattleText4:
	fartext _SaffronGymBattleText4
	done

SaffronGymEndBattleText4:
	fartext _SaffronGymEndBattleText4
	done

SaffronGymAfterBattleText4:
	fartext _SaffronGymAfterBattleText4
	done

SaffronGymBattleText5:
	fartext _SaffronGymBattleText5
	done

SaffronGymEndBattleText5:
	fartext _SaffronGymEndBattleText5
	done

SaffronGymAfterBattleText5:
	fartext _SaffronGymAfterBattleText5
	done

SaffronGymBattleText6:
	fartext _SaffronGymBattleText6
	done

SaffronGymEndBattleText6:
	fartext _SaffronGymEndBattleText6
	done

SaffronGymAfterBattleText6:
	fartext _SaffronGymAfterBattleText6
	done

SaffronGymBattleText7:
	fartext _SaffronGymBattleText7
	done

SaffronGymEndBattleText7:
	fartext _SaffronGymEndBattleText7
	done

SaffronGymAfterBattleText7:
	fartext _SaffronGymAfterBattleText7
	done
