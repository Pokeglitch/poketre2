VermilionGymScript:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	push hl
	call nz, VermilionGymScript_5ca4c
	pop hl
	bit 6, [hl]
	res 6, [hl]
	call nz, VermilionGymScript_5ca6d
	call EnableAutoTextBoxDrawing
	ld hl, VermilionGymTrainerHeader0
	ld de, VermilionGymScriptPointers
	ld a, [wVermilionGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wVermilionGymCurScript], a
	ret

VermilionGymScript_5ca4c:
	ld hl, Gym3CityName
	ld de, Gym3LeaderName
	jp LoadGymLeaderAndCityName

Gym3CityName:
	str "VERMILION CITY"

Gym3LeaderName:
	str "LT.SURGE"

VermilionGymScript_5ca6d:
	CheckEvent EVENT_2ND_LOCK_OPENED
	jr nz, .asm_5ca78
	ld a, $24
	jr .asm_5ca7f
.asm_5ca78
	ld a, SFX_GO_INSIDE
	call PlaySound
	ld a, $5
.asm_5ca7f
	ld [wNewTileBlockID], a
	lb bc, 2, 2
	predef_jump ReplaceTileBlock

VermilionGymScript_5ca8a:
	xor a
	ld [wJoyIgnore], a
	ld [wVermilionGymCurScript], a
	ld [wCurMapScript], a
	ret

VermilionGymScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw VermilionGymScript3

VermilionGymScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, VermilionGymScript_5ca8a
	ld a, $f0
	ld [wJoyIgnore], a

VermilionGymScript_5caaa:
	ld a, $6
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_LT_SURGE
	lb bc, TM_24, 1
	call GiveItem
	jr nc, .BagFull
	ld a, $7
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM24
	jr .asm_5cad3
.BagFull
	ld a, $8
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.asm_5cad3
	ld hl, wObtainedBadges
	set 2, [hl]
	ld hl, wBeatGymFlags
	set 2, [hl]

	; deactivate gym trainers
	SetEventRange EVENT_BEAT_VERMILION_GYM_TRAINER_0, EVENT_BEAT_VERMILION_GYM_TRAINER_2

	jp VermilionGymScript_5ca8a

VermilionGymTextPointers:
	dw VermilionGymText1
	dw VermilionGymText2
	dw VermilionGymText3
	dw VermilionGymText4
	dw VermilionGymText5
	dw VermilionGymText6
	dw VermilionGymText7
	dw VermilionGymText8

VermilionGymTrainerHeader0:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw VermilionGymBattleText1 ; TextBeforeBattle
	dw VermilionGymAfterBattleText1 ; TextAfterBattle
	dw VermilionGymEndBattleText1 ; TextEndBattle
	dw VermilionGymEndBattleText1 ; TextEndBattle

VermilionGymTrainerHeader1:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw VermilionGymBattleText2 ; TextBeforeBattle
	dw VermilionGymAfterBattleText2 ; TextAfterBattle
	dw VermilionGymEndBattleText2 ; TextEndBattle
	dw VermilionGymEndBattleText2 ; TextEndBattle

VermilionGymTrainerHeader2:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw VermilionGymBattleText3 ; TextBeforeBattle
	dw VermilionGymAfterBattleText3 ; TextAfterBattle
	dw VermilionGymEndBattleText3 ; TextEndBattle
	dw VermilionGymEndBattleText3 ; TextEndBattle

	db $ff

VermilionGymText1:
	asmtext
	CheckEvent EVENT_BEAT_LT_SURGE
	jr z, .asm_5cb39
	CheckEventReuseA EVENT_GOT_TM24
	jr nz, .asm_5cb31
	call z, VermilionGymScript_5caaa
	call DisableWaitingAfterTextDisplay
	jr .asm_5cb6a
.asm_5cb31
	ld hl, VermilionGymText_5cb72
	call PrintText
	jr .asm_5cb6a
.asm_5cb39
	ld hl, VermilionGymText_5cb6d
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, ReceivedThunderbadgeText
	ld de, ReceivedThunderbadgeText
	call SaveEndBattleTextPointers
	ld a, [H_SPRITEINDEX]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	ld a, $3
	ld [wGymLeaderNo], a
	xor a
	ld [hJoyHeld], a
	ld a, $3
	ld [wVermilionGymCurScript], a
	ld [wCurMapScript], a
.asm_5cb6a
	jp TextScriptEnd

VermilionGymText_5cb6d:
	fartext _VermilionGymText_5cb6d
	done

VermilionGymText_5cb72:
	fartext _VermilionGymText_5cb72
	done

VermilionGymText6:
	fartext _VermilionGymText_5cb77
	done

VermilionGymText7:
	fartext _ReceivedTM24Text
	sfxtext SFX_GET_KEY_ITEM
	fartext _TM24ExplanationText
	done

VermilionGymText8:
	fartext _TM24NoRoomText
	done

ReceivedThunderbadgeText:
	fartext _ReceivedThunderbadgeText
	done

VermilionGymText2:
	asmtext
	ld hl, VermilionGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

VermilionGymBattleText1:
	fartext _VermilionGymBattleText1
	done

VermilionGymEndBattleText1:
	fartext _VermilionGymEndBattleText1
	done

VermilionGymAfterBattleText1:
	fartext _VermilionGymAfterBattleText1
	done

VermilionGymText3:
	asmtext
	ld hl, VermilionGymTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

VermilionGymBattleText2:
	fartext _VermilionGymBattleText2
	done

VermilionGymEndBattleText2:
	fartext _VermilionGymEndBattleText2
	done

VermilionGymAfterBattleText2:
	fartext _VermilionGymAfterBattleText2
	done

VermilionGymText4:
	asmtext
	ld hl, VermilionGymTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

VermilionGymBattleText3:
	fartext _VermilionGymBattleText3
	done

VermilionGymEndBattleText3:
	fartext _VermilionGymEndBattleText3
	done

VermilionGymAfterBattleText3:
	fartext _VermilionGymAfterBattleText3
	done

VermilionGymText5:
	asmtext
	ld a, [wBeatGymFlags]
	bit 2, a
	jr nz, .asm_5cbeb
	ld hl, VermilionGymText_5cbf4
	call PrintText
	jr .asm_5cbf1
.asm_5cbeb
	ld hl, VermilionGymText_5cbf9
	call PrintText
.asm_5cbf1
	jp TextScriptEnd

VermilionGymText_5cbf4:
	fartext _VermilionGymText_5cbf4
	done

VermilionGymText_5cbf9:
	fartext _VermilionGymText_5cbf9
	done
