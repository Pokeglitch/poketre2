Route6Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route6TrainerHeader0
	ld de, Route6ScriptPointers
	ld a, [wRoute6CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute6CurScript], a
	ret

Route6ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route6TextPointers:
	dw Route6Text1
	dw Route6Text2
	dw Route6Text3
	dw Route6Text4
	dw Route6Text5
	dw Route6Text6
	dw Route6Text7

Route6TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROUTE_6_TRAINER_0
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_6_TRAINER_0
	dw Route6BattleText1 ; TextBeforeBattle
	dw Route6AfterBattleText1 ; TextAfterBattle
	dw Route6EndBattleText1 ; TextEndBattle
	dw Route6EndBattleText1 ; TextEndBattle

Route6TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_ROUTE_6_TRAINER_1
	db ($0 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_6_TRAINER_1
	dw Route6BattleText2 ; TextBeforeBattle
	dw Route6AfterBattleText1 ; TextAfterBattle
	dw Route6EndBattleText2 ; TextEndBattle
	dw Route6EndBattleText2 ; TextEndBattle

Route6TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_ROUTE_6_TRAINER_2
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_6_TRAINER_2
	dw Route6BattleText3 ; TextBeforeBattle
	dw Route6AfterBattleText3 ; TextAfterBattle
	dw Route6EndBattleText3 ; TextEndBattle
	dw Route6EndBattleText3 ; TextEndBattle

Route6TrainerHeader3:
	dbEventFlagBit EVENT_BEAT_ROUTE_6_TRAINER_3
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_6_TRAINER_3
	dw Route6BattleText4 ; TextBeforeBattle
	dw Route6AfterBattleText4 ; TextAfterBattle
	dw Route6EndBattleText4 ; TextEndBattle
	dw Route6EndBattleText4 ; TextEndBattle

Route6TrainerHeader4:
	dbEventFlagBit EVENT_BEAT_ROUTE_6_TRAINER_4
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_6_TRAINER_4
	dw Route6BattleText5 ; TextBeforeBattle
	dw Route6AfterBattleText5 ; TextAfterBattle
	dw Route6EndBattleText5 ; TextEndBattle
	dw Route6EndBattleText5 ; TextEndBattle

Route6TrainerHeader5:
	dbEventFlagBit EVENT_BEAT_ROUTE_6_TRAINER_5
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_6_TRAINER_5
	dw Route6BattleText6 ; TextBeforeBattle
	dw Route6AfterBattleText6 ; TextAfterBattle
	dw Route6EndBattleText6 ; TextEndBattle
	dw Route6EndBattleText6 ; TextEndBattle

	db $ff

Route6Text1:
	asmtext
	ld hl, Route6TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route6BattleText1:
	fartext _Route6BattleText1
	done

Route6EndBattleText1:
	fartext _Route6EndBattleText1
	done

Route6AfterBattleText1:
	fartext _Route6AfterBattleText1
	done

Route6Text2:
	asmtext
	ld hl, Route6TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route6BattleText2:
	fartext _Route6BattleText2
	done

Route6EndBattleText2:
	fartext _Route6EndBattleText2
	done

Route6Text3:
	asmtext
	ld hl, Route6TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route6BattleText3:
	fartext _Route6BattleText3
	done

Route6EndBattleText3:
	fartext _Route6EndBattleText3
	done

Route6AfterBattleText3:
	fartext _Route6AfterBattleText3
	done

Route6Text4:
	asmtext
	ld hl, Route6TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route6BattleText4:
	fartext _Route6BattleText4
	done

Route6EndBattleText4:
	fartext _Route6EndBattleText4
	done

Route6AfterBattleText4:
	fartext _Route6AfterBattleText4
	done

Route6Text5:
	asmtext
	ld hl, Route6TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route6BattleText5:
	fartext _Route6BattleText5
	done

Route6EndBattleText5:
	fartext _Route6EndBattleText5
	done

Route6AfterBattleText5:
	fartext _Route6AfterBattleText5
	done

Route6Text6:
	asmtext
	ld hl, Route6TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route6BattleText6:
	fartext _Route6BattleText6
	done

Route6EndBattleText6:
	fartext _Route6EndBattleText6
	done

Route6AfterBattleText6:
	fartext _Route6AfterBattleText6
	done

Route6Text7:
	fartext _Route6Text7
	done
