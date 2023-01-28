CinnabarGymScript:
	call CinnabarGymScript_75759
	call EnableAutoTextBoxDrawing
	ld hl, CinnabarGymScriptPointers
	ld a, [wCinnabarGymCurScript]
	jp CallFunctionInTable

CinnabarGymScript_75759:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	push hl
	call nz, CinnabarGymScript_75772
	pop hl
	bit 5, [hl]
	res 5, [hl]
	call nz, UpdateCinnabarGymGateTileBlocks
	ResetEvent EVENT_2A7
	ret
CinnabarGymScript_75772:
	ld hl, Gym7CityName
	ld de, Gym7LeaderName
	jp LoadGymLeaderAndCityName

Gym7CityName:
	str "CINNABAR ISLAND"
Gym7LeaderName:
	str "BLAINE"

CinnabarGymScript_75792:
	xor a
	ld [wJoyIgnore], a
	ld [wCinnabarGymCurScript], a
	ld [wCurMapScript], a
	ld [wOpponentAfterWrongAnswer], a
	ret

CinnabarGymScript_757a0:
	ld a, [hSpriteIndexOrTextID]
	ld [wTrainerHeaderFlagBit], a
	ret

CinnabarGymScriptPointers:
	dw CinnabarGymScript0
	dw CinnabarGymScript1
	dw CinnabarGymScript2
	dw CinnabarGymScript3

CinnabarGymScript0:
	ld a, [wOpponentAfterWrongAnswer]
	and a
	ret z
	ld [H_SPRITEINDEX], a
	cp $4
	jr nz, .asm_757c3
	ld a, PLAYER_DIR_DOWN
	ld [wPlayerMovingDirection], a
	ld de, MovementData_757d7
	jr .asm_757cb
.asm_757c3
	ld de, MovementData_757da
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
.asm_757cb
	call MoveSprite
	ld a, $1
	ld [wCinnabarGymCurScript], a
	ld [wCurMapScript], a
	ret

MovementData_757d7:
	db NPC_MOVEMENT_LEFT
	db NPC_MOVEMENT_UP
	db $FF

MovementData_757da:
	db NPC_MOVEMENT_LEFT
	db $FF

CinnabarGymScript1:
	ld a, [wd730]
	bit 0, a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, [wOpponentAfterWrongAnswer]
	ld [wTrainerHeaderFlagBit], a
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID

CinnabarGymFlagAction:
	predef_jump FlagActionPredef

CinnabarGymScript2:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CinnabarGymScript_75792
	ld a, [wTrainerHeaderFlagBit]
	ld [$ffdb], a
	AdjustEventBit EVENT_BEAT_CINNABAR_GYM_TRAINER_0, 2
	ld c, a
	ld b, FLAG_TEST
	EventFlagAddress hl, EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	call CinnabarGymFlagAction
	ld a, c
	and a
	jr nz, .asm_7581b
	call WaitForSoundToFinish
	ld a, SFX_GO_INSIDE
	call PlaySound
	call WaitForSoundToFinish
.asm_7581b
	ld a, [wTrainerHeaderFlagBit]
	ld [$ffdb], a
	AdjustEventBit EVENT_BEAT_CINNABAR_GYM_TRAINER_0, 2
	ld c, a
	ld b, FLAG_SET
	EventFlagAddress hl, EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	call CinnabarGymFlagAction
	ld a, [wTrainerHeaderFlagBit]
	sub $2
	AdjustEventBit EVENT_CINNABAR_GYM_GATE0_UNLOCKED, 0
	ld c, a
	ld b, FLAG_SET
	EventFlagAddress hl, EVENT_CINNABAR_GYM_GATE0_UNLOCKED
	call CinnabarGymFlagAction
	call UpdateCinnabarGymGateTileBlocks
	xor a
	ld [wJoyIgnore], a
	ld [wOpponentAfterWrongAnswer], a
	ld a, $0
	ld [wCinnabarGymCurScript], a
	ld [wCurMapScript], a
	ret

CinnabarGymScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, CinnabarGymScript_75792
	ld a, $f0
	ld [wJoyIgnore], a
CinnabarGymScript3_75857:
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_BLAINE
	lb bc, TM_38, 1
	call GiveItem
	jr nc, .BagFull
	ld a, $b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM38
	jr .asm_75880
.BagFull
	ld a, $c
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.asm_75880
	ld hl, wObtainedBadges
	set 6, [hl]
	ld hl, wBeatGymFlags
	set 6, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_CINNABAR_GYM_TRAINER_0, EVENT_BEAT_CINNABAR_GYM_TRAINER_6

	ld hl, wCurrentMapScriptFlags
	set 5, [hl]

	jp CinnabarGymScript_75792

CinnabarGymTrainerHeader0:
	db TrainerHeaderTerminator

CinnabarGymTextPointers:
	dw CinnabarGymText1
	dw CinnabarGymText2
	dw CinnabarGymText3
	dw CinnabarGymText4
	dw CinnabarGymText5
	dw CinnabarGymText6
	dw CinnabarGymText7
	dw CinnabarGymText8
	dw CinnabarGymText9
	dw BlaineBadgeText
	dw ReceivedTM38Text
	dw TM38NoRoomText

CinnabarGymScript_758b7:
	ld a, [hSpriteIndexOrTextID]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld a, [wSpriteIndex]
	cp $1
	jr z, .asm_758d4
	ld a, $2
	jr .asm_758d6
.asm_758d4
	ld a, $3
.asm_758d6
	ld [wCinnabarGymCurScript], a
	ld [wCurMapScript], a
	jp TextScriptEnd

CinnabarGymText1:
	asmtext
	CheckEvent EVENT_BEAT_BLAINE
	jr z, .asm_d9332
	CheckEventReuseA EVENT_GOT_TM38
	jr nz, .asm_3012f
	call z, CinnabarGymScript3_75857
	call DisableWaitingAfterTextDisplay
	jp TextScriptEnd
.asm_3012f
	ld hl, BlaineFireBlastText
	call PrintText
	jp TextScriptEnd
.asm_d9332
	ld hl, BlaineBattleText
	call PrintText
	ld hl, BlaineEndBattleText
	ld de, BlaineEndBattleText
	call SaveEndBattleTextPointers
	ld a, $7
	ld [wGymLeaderNo], a
	jp CinnabarGymScript_758b7

BlaineBattleText:
	fartext _BlaineBattleText
	done

BlaineEndBattleText:
	fartext _BlaineEndBattleText
	sfxtext SFX_GET_KEY_ITEM ; actually plays the second channel of SFX_BALL_POOF due to the wrong music bank being loaded
	wait
	done

BlaineFireBlastText:
	fartext _BlaineFireBlastText
	done

BlaineBadgeText:
	fartext _BlaineBadgeText
	done

ReceivedTM38Text:
	fartext _ReceivedTM38Text
	sfxtext SFX_GET_ITEM_1
	fartext _TM38ExplanationText
	done

TM38NoRoomText:
	fartext _TM38NoRoomText
	done

CinnabarGymText2:
	asmtext
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_0
	jr nz, .asm_46bb4
	ld hl, CinnabarGymText_7595f
	call PrintText
	ld hl, CinnabarGymText_75964
	ld de, CinnabarGymText_75964
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_46bb4
	ld hl, CinnabarGymText_75969
	call PrintText
	jp TextScriptEnd

CinnabarGymText_7595f:
	fartext _CinnabarGymText_7595f
	done

CinnabarGymText_75964:
	fartext _CinnabarGymText_75964
	done

CinnabarGymText_75969:
	fartext _CinnabarGymText_75969
	done

CinnabarGymText3:
	asmtext
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_1
	jr nz, .asm_4b406
	ld hl, CinnabarGymText_75994
	call PrintText
	ld hl, CinnabarGymText_75999
	ld de, CinnabarGymText_75999
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_4b406
	ld hl, CinnabarGymText_7599e
	call PrintText
	jp TextScriptEnd

CinnabarGymText_75994:
	fartext _CinnabarGymText_75994
	done

CinnabarGymText_75999:
	fartext _CinnabarGymText_75999
	done

CinnabarGymText_7599e:
	fartext _CinnabarGymText_7599e
	done

CinnabarGymText4:
	asmtext
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_2
	jr nz, .asm_c0673
	ld hl, CinnabarGymText_759c9
	call PrintText
	ld hl, CinnabarGymText_759ce
	ld de, CinnabarGymText_759ce
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_c0673
	ld hl, CinnabarGymText_759d3
	call PrintText
	jp TextScriptEnd

CinnabarGymText_759c9:
	fartext _CinnabarGymText_759c9
	done

CinnabarGymText_759ce:
	fartext _CinnabarGymText_759ce
	done

CinnabarGymText_759d3:
	fartext _CinnabarGymText_759d3
	done

CinnabarGymText5:
	asmtext
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_3
	jr nz, .asm_5cfd7
	ld hl, CinnabarGymText_759fe
	call PrintText
	ld hl, CinnabarGymText_75a03
	ld de, CinnabarGymText_75a03
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_5cfd7
	ld hl, CinnabarGymText_75a08
	call PrintText
	jp TextScriptEnd

CinnabarGymText_759fe:
	fartext _CinnabarGymText_759fe
	done

CinnabarGymText_75a03:
	fartext _CinnabarGymText_75a03
	done

CinnabarGymText_75a08:
	fartext _CinnabarGymText_75a08
	done

CinnabarGymText6:
	asmtext
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_4
	jr nz, .asm_776b4
	ld hl, CinnabarGymText_75a33
	call PrintText
	ld hl, CinnabarGymText_75a38
	ld de, CinnabarGymText_75a38
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_776b4
	ld hl, CinnabarGymText_75a3d
	call PrintText
	jp TextScriptEnd

CinnabarGymText_75a33:
	fartext _CinnabarGymText_75a33
	done

CinnabarGymText_75a38:
	fartext _CinnabarGymText_75a38
	done

CinnabarGymText_75a3d:
	fartext _CinnabarGymText_75a3d
	done

CinnabarGymText7:
	asmtext
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_5
	jr nz, .asm_2f755
	ld hl, CinnabarGymText_75a68
	call PrintText
	ld hl, CinnabarGymText_75a6d
	ld de, CinnabarGymText_75a6d
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_2f755
	ld hl, CinnabarGymText_75a72
	call PrintText
	jp TextScriptEnd

CinnabarGymText_75a68:
	fartext _CinnabarGymText_75a68
	done

CinnabarGymText_75a6d:
	fartext _CinnabarGymText_75a6d
	done

CinnabarGymText_75a72:
	fartext _CinnabarGymText_75a72
	done

CinnabarGymText8:
	asmtext
	call CinnabarGymScript_757a0
	CheckEvent EVENT_BEAT_CINNABAR_GYM_TRAINER_6
	jr nz, .asm_d87be
	ld hl, CinnabarGymText_75a9d
	call PrintText
	ld hl, CinnabarGymText_75aa2
	ld de, CinnabarGymText_75aa2
	call SaveEndBattleTextPointers
	jp CinnabarGymScript_758b7
.asm_d87be
	ld hl, CinnabarGymText_75aa7
	call PrintText
	jp TextScriptEnd

CinnabarGymText_75a9d:
	fartext _CinnabarGymText_75a9d
	done

CinnabarGymText_75aa2:
	fartext _CinnabarGymText_75aa2
	done

CinnabarGymText_75aa7:
	fartext _CinnabarGymText_75aa7
	done

CinnabarGymText9:
	asmtext
	CheckEvent EVENT_BEAT_BLAINE
	jr nz, .asm_627d9
	ld hl, CinnabarGymText_75ac2
	jr .asm_0b11d
.asm_627d9
	ld hl, CinnabarGymText_75ac7
.asm_0b11d
	call PrintText
	jp TextScriptEnd

CinnabarGymText_75ac2:
	fartext _CinnabarGymText_75ac2
	done

CinnabarGymText_75ac7:
	fartext _CinnabarGymText_75ac7
	done
