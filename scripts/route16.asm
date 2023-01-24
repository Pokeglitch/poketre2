Route16Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route16TrainerHeader0
	ld de, Route16ScriptPointers
	ld a, [wRoute16CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute16CurScript], a
	ret

Route16Script_59946:
	xor a
	ld [wJoyIgnore], a
	ld [wRoute16CurScript], a
	ld [wCurMapScript], a
	ret

Route16ScriptPointers:
	dw Route16Script0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw Route16Script3

Route16Script0:
	CheckEventHL EVENT_BEAT_ROUTE16_SNORLAX
	jp nz, CheckFightingMapTrainers
	CheckEventReuseHL EVENT_FIGHT_ROUTE16_SNORLAX
	ResetEventReuseHL EVENT_FIGHT_ROUTE16_SNORLAX
	jp z, CheckFightingMapTrainers
	ld a, $a
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	PrepareBattle SNORLAX, 30
	ld a, HS_ROUTE_16_SNORLAX
	ld [wMissableObjectIndex], a
	predef HideObject
	call UpdateSprites
	ld a, $3
	ld [wRoute16CurScript], a
	ld [wCurMapScript], a
	ret

Route16Script3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, Route16Script_59946
	call UpdateSprites
	ld a, [wBattleResult]
	cp $2
	jr z, .asm_599a8
	ld a, $b
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
.asm_599a8
	SetEvent EVENT_BEAT_ROUTE16_SNORLAX
	call Delay3
	ld a, $0
	ld [wRoute16CurScript], a
	ld [wCurMapScript], a
	ret

Route16TextPointers:
	dw Route16Text1
	dw Route16Text2
	dw Route16Text3
	dw Route16Text4
	dw Route16Text5
	dw Route16Text6
	dw Route16Text7
	dw Route16Text8
	dw Route16Text9
	dw Route16Text10
	dw Route16Text11

Route16TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROUTE_16_TRAINER_0
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_16_TRAINER_0
	dw Route16BattleText1 ; TextBeforeBattle
	dw Route16AfterBattleText1 ; TextAfterBattle
	dw Route16EndBattleText1 ; TextEndBattle
	dw Route16EndBattleText1 ; TextEndBattle

Route16TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_ROUTE_16_TRAINER_1
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_16_TRAINER_1
	dw Route16BattleText2 ; TextBeforeBattle
	dw Route16AfterBattleText2 ; TextAfterBattle
	dw Route16EndBattleText2 ; TextEndBattle
	dw Route16EndBattleText2 ; TextEndBattle

Route16TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_ROUTE_16_TRAINER_2
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_16_TRAINER_2
	dw Route16BattleText3 ; TextBeforeBattle
	dw Route16AfterBattleText3 ; TextAfterBattle
	dw Route16EndBattleText3 ; TextEndBattle
	dw Route16EndBattleText3 ; TextEndBattle

Route16TrainerHeader3:
	dbEventFlagBit EVENT_BEAT_ROUTE_16_TRAINER_3
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_16_TRAINER_3
	dw Route16BattleText4 ; TextBeforeBattle
	dw Route16AfterBattleText4 ; TextAfterBattle
	dw Route16EndBattleText4 ; TextEndBattle
	dw Route16EndBattleText4 ; TextEndBattle

Route16TrainerHeader4:
	dbEventFlagBit EVENT_BEAT_ROUTE_16_TRAINER_4
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_16_TRAINER_4
	dw Route16BattleText5 ; TextBeforeBattle
	dw Route16AfterBattleText5 ; TextAfterBattle
	dw Route16EndBattleText5 ; TextEndBattle
	dw Route16EndBattleText5 ; TextEndBattle

Route16TrainerHeader5:
	dbEventFlagBit EVENT_BEAT_ROUTE_16_TRAINER_5
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_16_TRAINER_5
	dw Route16BattleText6 ; TextBeforeBattle
	dw Route16AfterBattleText6 ; TextAfterBattle
	dw Route16EndBattleText6 ; TextEndBattle
	dw Route16EndBattleText6 ; TextEndBattle

	db $ff

Route16Text1:
	asmtext
	ld hl, Route16TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route16BattleText1:
	fartext _Route16BattleText1
	done

Route16EndBattleText1:
	fartext _Route16EndBattleText1
	done

Route16AfterBattleText1:
	fartext _Route16AfterBattleText1
	done

Route16Text2:
	asmtext
	ld hl, Route16TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route16BattleText2:
	fartext _Route16BattleText2
	done

Route16EndBattleText2:
	fartext _Route16EndBattleText2
	done

Route16AfterBattleText2:
	fartext _Route16AfterBattleText2
	done

Route16Text3:
	asmtext
	ld hl, Route16TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route16BattleText3:
	fartext _Route16BattleText3
	done

Route16EndBattleText3:
	fartext _Route16EndBattleText3
	done

Route16AfterBattleText3:
	fartext _Route16AfterBattleText3
	done

Route16Text4:
	asmtext
	ld hl, Route16TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route16BattleText4:
	fartext _Route16BattleText4
	done

Route16EndBattleText4:
	fartext _Route16EndBattleText4
	done

Route16AfterBattleText4:
	fartext _Route16AfterBattleText4
	done

Route16Text5:
	asmtext
	ld hl, Route16TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route16BattleText5:
	fartext _Route16BattleText5
	done

Route16EndBattleText5:
	fartext _Route16EndBattleText5
	done

Route16AfterBattleText5:
	fartext _Route16AfterBattleText5
	done

Route16Text6:
	asmtext
	ld hl, Route16TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route16BattleText6:
	fartext _Route16BattleText6
	done

Route16EndBattleText6:
	fartext _Route16EndBattleText6
	done

Route16AfterBattleText6:
	fartext _Route16AfterBattleText6
	done

Route16Text7:
	fartext _Route16Text7
	done

Route16Text10:
	fartext _Route16Text10
	done

Route16Text11:
	fartext _Route16Text11
	done

Route16Text8:
	fartext _Route16Text8
	done

Route16Text9:
	fartext _Route16Text9
	done
