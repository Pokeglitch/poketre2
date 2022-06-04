FightingDojoScript:
	call EnableAutoTextBoxDrawing
	ld hl, FightingDojoTrainerHeader0
	ld de, FightingDojoScriptPointers
	ld a, [wFightingDojoCurScript]
	call ExecuteCurMapScriptInTable
	ld [wFightingDojoCurScript], a
	ret

FightingDojoScript_5cd70:
	xor a
	ld [wJoyIgnore], a
	ld [wFightingDojoCurScript], a
	ld [wCurMapScript], a
	ret

FightingDojoScriptPointers:
	dw FightingDojoScript1
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw FightingDojoScript3

FightingDojoScript1:
	CheckEvent EVENT_DEFEATED_FIGHTING_DOJO
	ret nz
	call CheckFightingMapTrainers
	ld a, [wTrainerHeaderFlagBit]
	and a
	ret nz
	CheckEvent EVENT_BEAT_KARATE_MASTER
	ret nz
	xor a
	ld [hJoyHeld], a
	ld [wcf0d], a
	ld a, [wYCoord]
	cp $3
	ret nz
	ld a, [wXCoord]
	cp $4
	ret nz
	ld a, $1
	ld [wcf0d], a
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_LEFT
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ret

FightingDojoScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, FightingDojoScript_5cd70
	ld a, [wcf0d]
	and a
	jr z, .asm_5cde4
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, $1
	ld [H_SPRITEINDEX], a
	ld a, SPRITE_FACING_LEFT
	ld [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay

.asm_5cde4
	ld a, $f0
	ld [wJoyIgnore], a
	SetEventRange EVENT_BEAT_KARATE_MASTER, EVENT_BEAT_FIGHTING_DOJO_TRAINER_3
	ld a, $8
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [wJoyIgnore], a
	ld [wFightingDojoCurScript], a
	ld [wCurMapScript], a
	ret

FightingDojoTextPointers:
	dw FightingDojoText1
	dw FightingDojoText2
	dw FightingDojoText3
	dw FightingDojoText4
	dw FightingDojoText5
	dw FightingDojoText6
	dw FightingDojoText7
	dw FightingDojoText8

FightingDojoTrainerHeader0:
	dbEventFlagBit EVENT_BEAT_FIGHTING_DOJO_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FIGHTING_DOJO_TRAINER_0
	dw FightingDojoBattleText1 ; TextBeforeBattle
	dw FightingDojoAfterBattleText1 ; TextAfterBattle
	dw FightingDojoEndBattleText1 ; TextEndBattle
	dw FightingDojoEndBattleText1 ; TextEndBattle

FightingDojoTrainerHeader1:
	dbEventFlagBit EVENT_BEAT_FIGHTING_DOJO_TRAINER_1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FIGHTING_DOJO_TRAINER_1
	dw FightingDojoBattleText2 ; TextBeforeBattle
	dw FightingDojoAfterBattleText2 ; TextAfterBattle
	dw FightingDojoEndBattleText2 ; TextEndBattle
	dw FightingDojoEndBattleText2 ; TextEndBattle

FightingDojoTrainerHeader2:
	dbEventFlagBit EVENT_BEAT_FIGHTING_DOJO_TRAINER_2
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FIGHTING_DOJO_TRAINER_2
	dw FightingDojoBattleText3 ; TextBeforeBattle
	dw FightingDojoAfterBattleText3 ; TextAfterBattle
	dw FightingDojoEndBattleText3 ; TextEndBattle
	dw FightingDojoEndBattleText3 ; TextEndBattle

FightingDojoTrainerHeader3:
	dbEventFlagBit EVENT_BEAT_FIGHTING_DOJO_TRAINER_3
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_FIGHTING_DOJO_TRAINER_3
	dw FightingDojoBattleText4 ; TextBeforeBattle
	dw FightingDojoAfterBattleText4 ; TextAfterBattle
	dw FightingDojoEndBattleText4 ; TextEndBattle
	dw FightingDojoEndBattleText4 ; TextEndBattle

	db $ff

FightingDojoText1:
	asmtext
	CheckEvent EVENT_DEFEATED_FIGHTING_DOJO
	jp nz, .continue1
	CheckEventReuseA EVENT_BEAT_KARATE_MASTER
	jp nz, .continue2
	ld hl, FightingDojoText_5ce8e
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, FightingDojoText_5ce93
	ld de, FightingDojoText_5ce93
	call SaveEndBattleTextPointers
	ld a, [hSpriteIndexOrTextID]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $3
	ld [wFightingDojoCurScript], a
	ld [wCurMapScript], a
	jr .asm_9dba4
.continue1
	ld hl, FightingDojoText_5ce9d
	call PrintText
	jr .asm_9dba4
.continue2
	ld hl, FightingDojoText8
	call PrintText
.asm_9dba4
	jp TextScriptEnd

FightingDojoText_5ce8e:
	fartext _FightingDojoText_5ce8e
	done

FightingDojoText_5ce93:
	fartext _FightingDojoText_5ce93
	done

FightingDojoText8:
	fartext _FightingDojoText_5ce98
	done

FightingDojoText_5ce9d:
	fartext _FightingDojoText_5ce9d
	done

FightingDojoText2:
	asmtext
	ld hl, FightingDojoTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

FightingDojoBattleText1:
	fartext _FightingDojoBattleText1
	done

FightingDojoEndBattleText1:
	fartext _FightingDojoEndBattleText1
	done

FightingDojoAfterBattleText1:
	fartext _FightingDojoAfterBattleText1
	done

FightingDojoText3:
	asmtext
	ld hl, FightingDojoTrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

FightingDojoBattleText2:
	fartext _FightingDojoBattleText2
	done

FightingDojoEndBattleText2:
	fartext _FightingDojoEndBattleText2
	done

FightingDojoAfterBattleText2:
	fartext _FightingDojoAfterBattleText2
	done

FightingDojoText4:
	asmtext
	ld hl, FightingDojoTrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

FightingDojoBattleText3:
	fartext _FightingDojoBattleText3
	done

FightingDojoEndBattleText3:
	fartext _FightingDojoEndBattleText3
	done

FightingDojoAfterBattleText3:
	fartext _FightingDojoAfterBattleText3
	done

FightingDojoText5:
	asmtext
	ld hl, FightingDojoTrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

FightingDojoBattleText4:
	fartext _FightingDojoBattleText4
	done

FightingDojoEndBattleText4:
	fartext _FightingDojoEndBattleText4
	done

FightingDojoAfterBattleText4:
	fartext _FightingDojoAfterBattleText4
	done

FightingDojoText6:
; Hitmonlee Poké Ball
	asmtext
	CheckEitherEventSet EVENT_GOT_HITMONLEE, EVENT_GOT_HITMONCHAN
	jr z, .GetMon
	ld hl, OtherHitmonText
	call PrintText
	jr .done
.GetMon
	ld a, HITMONLEE
	call DisplayPokedex
	ld hl, WantHitmonleeText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .done
	ld a, [wcf91]
	ld b, a
	ld c, 30
	call GivePokemon
	jr nc, .done

	; once Poké Ball is taken, hide sprite
	ld a, HS_FIGHTING_DOJO_GIFT_1
	ld [wMissableObjectIndex], a
	predef HideObject
	SetEvents EVENT_GOT_HITMONLEE, EVENT_DEFEATED_FIGHTING_DOJO
.done
	jp TextScriptEnd

WantHitmonleeText:
	fartext _WantHitmonleeText
	done

FightingDojoText7:
; Hitmonchan Poké Ball
	asmtext
	CheckEitherEventSet EVENT_GOT_HITMONLEE, EVENT_GOT_HITMONCHAN
	jr z, .GetMon
	ld hl, OtherHitmonText
	call PrintText
	jr .done
.GetMon
	ld a, HITMONCHAN
	call DisplayPokedex
	ld hl, WantHitmonchanText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .done
	ld a, [wcf91]
	ld b, a
	ld c, 30
	call GivePokemon
	jr nc, .done
	SetEvents EVENT_GOT_HITMONCHAN, EVENT_DEFEATED_FIGHTING_DOJO

	; once Poké Ball is taken, hide sprite
	ld a, HS_FIGHTING_DOJO_GIFT_2
	ld [wMissableObjectIndex], a
	predef HideObject
.done
	jp TextScriptEnd

WantHitmonchanText:
	fartext _WantHitmonchanText
	done

OtherHitmonText:
	fartext _OtherHitmonText
	done
