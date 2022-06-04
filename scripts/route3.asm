Route3Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route3TrainerHeader0
	ld de, Route3ScriptPointers
	ld a, [wRoute3CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute3CurScript], a
	ret

Route3ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route3TextPointers:
	dw Route3Text1
	dw Route3Text2
	dw Route3Text3
	dw Route3Text4
	dw Route3Text5
	dw Route3Text6
	dw Route3Text7
	dw Route3Text8
	dw Route3Text9
	dw Route3Text10

Route3TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROUTE_3_TRAINER_0
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_3_TRAINER_0
	dw Route3BattleText1 ; TextBeforeBattle
	dw Route3AfterBattleText1 ; TextAfterBattle
	dw Route3EndBattleText1 ; TextEndBattle
	dw Route3EndBattleText1 ; TextEndBattle

Route3TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_ROUTE_3_TRAINER_1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_3_TRAINER_1
	dw Route3BattleText2 ; TextBeforeBattle
	dw Route3AfterBattleText2 ; TextAfterBattle
	dw Route3EndBattleText2 ; TextEndBattle
	dw Route3EndBattleText2 ; TextEndBattle

Route3TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_ROUTE_3_TRAINER_2
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_3_TRAINER_2
	dw Route3BattleText3 ; TextBeforeBattle
	dw Route3AfterBattleText3 ; TextAfterBattle
	dw Route3EndBattleText3 ; TextEndBattle
	dw Route3EndBattleText3 ; TextEndBattle

Route3TrainerHeader3:
	dbEventFlagBit EVENT_BEAT_ROUTE_3_TRAINER_3
	db ($1 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_3_TRAINER_3
	dw Route3BattleText4 ; TextBeforeBattle
	dw Route3AfterBattleText4 ; TextAfterBattle
	dw Route3EndBattleText4 ; TextEndBattle
	dw Route3EndBattleText4 ; TextEndBattle

Route3TrainerHeader4:
	dbEventFlagBit EVENT_BEAT_ROUTE_3_TRAINER_4
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_3_TRAINER_4
	dw Route3BattleText5 ; TextBeforeBattle
	dw Route3AfterBattleText5 ; TextAfterBattle
	dw Route3EndBattleText5 ; TextEndBattle
	dw Route3EndBattleText5 ; TextEndBattle

Route3TrainerHeader5:
	dbEventFlagBit EVENT_BEAT_ROUTE_3_TRAINER_5
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_3_TRAINER_5
	dw Route3BattleText6 ; TextBeforeBattle
	dw Route3AfterBattleText6 ; TextAfterBattle
	dw Route3EndBattleText6 ; TextEndBattle
	dw Route3EndBattleText6 ; TextEndBattle

Route3TrainerHeader6:
	dbEventFlagBit EVENT_BEAT_ROUTE_3_TRAINER_6, 1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_3_TRAINER_6, 1
	dw Route3BattleText7 ; TextBeforeBattle
	dw Route3AfterBattleText7 ; TextAfterBattle
	dw Route3EndBattleText7 ; TextEndBattle
	dw Route3EndBattleText7 ; TextEndBattle

Route3TrainerHeader7:
	dbEventFlagBit EVENT_BEAT_ROUTE_3_TRAINER_7, 1
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_3_TRAINER_7, 1
	dw Route3BattleText8 ; TextBeforeBattle
	dw Route3AfterBattleText8 ; TextAfterBattle
	dw Route3EndBattleText8 ; TextEndBattle
	dw Route3EndBattleText8 ; TextEndBattle

	db $ff

Route3Text1:
	text ""
	fartext _Route3Text1
	done

Route3Text2:
	TX_ASM
	ld hl, Route3TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText1:
	text ""
	fartext _Route3BattleText1
	done

Route3EndBattleText1:
	text ""
	fartext _Route3EndBattleText1
	done

Route3AfterBattleText1:
	text ""
	fartext _Route3AfterBattleText1
	done

Route3Text3:
	TX_ASM
	ld hl, Route3TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText2:
	text ""
	fartext _Route3BattleText2
	done

Route3EndBattleText2:
	text ""
	fartext _Route3EndBattleText2
	done

Route3AfterBattleText2:
	text ""
	fartext _Route3AfterBattleText2
	done

Route3Text4:
	TX_ASM
	ld hl, Route3TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText3:
	text ""
	fartext _Route3BattleText3
	done

Route3EndBattleText3:
	text ""
	fartext _Route3EndBattleText3
	done

Route3AfterBattleText3:
	text ""
	fartext _Route3AfterBattleText3
	done

Route3Text5:
	TX_ASM
	ld hl, Route3TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText4:
	text ""
	fartext _Route3BattleText4
	done

Route3EndBattleText4:
	text ""
	fartext _Route3EndBattleText4
	done

Route3AfterBattleText4:
	text ""
	fartext _Route3AfterBattleText4
	done

Route3Text6:
	TX_ASM
	ld hl, Route3TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText5:
	text ""
	fartext _Route3BattleText5
	done

Route3EndBattleText5:
	text ""
	fartext _Route3EndBattleText5
	done

Route3AfterBattleText5:
	text ""
	fartext _Route3AfterBattleText5
	done

Route3Text7:
	TX_ASM
	ld hl, Route3TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText6:
	text ""
	fartext _Route3BattleText6
	done

Route3EndBattleText6:
	text ""
	fartext _Route3EndBattleText6
	done

Route3AfterBattleText6:
	text ""
	fartext _Route3AfterBattleText6
	done

Route3Text8:
	TX_ASM
	ld hl, Route3TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText7:
	text ""
	fartext _Route3BattleText7
	done

Route3EndBattleText7:
	text ""
	fartext _Route3EndBattleText7
	done

Route3AfterBattleText7:
	text ""
	fartext _Route3AfterBattleText7
	done

Route3Text9:
	TX_ASM
	ld hl, Route3TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText8:
	text ""
	fartext _Route3BattleText8
	done

Route3EndBattleText8:
	text ""
	fartext _Route3EndBattleText8
	done

Route3AfterBattleText8:
	text ""
	fartext _Route3AfterBattleText8
	done

Route3Text10:
	text ""
	fartext _Route3Text10
	done
