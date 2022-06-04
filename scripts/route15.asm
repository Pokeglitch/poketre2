Route15Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route15TrainerHeader0
	ld de, Route15ScriptPointers
	ld a, [wRoute15CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute15CurScript], a
	ret

Route15ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route15TextPointers:
	dw Route15Text1
	dw Route15Text2
	dw Route15Text3
	dw Route15Text4
	dw Route15Text5
	dw Route15Text6
	dw Route15Text7
	dw Route15Text8
	dw Route15Text9
	dw Route15Text10
	dw PickUpItemText
	dw Route15Text12

Route15TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROUTE_15_TRAINER_0
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_15_TRAINER_0
	dw Route15BattleText1 ; TextBeforeBattle
	dw Route15AfterBattleText1 ; TextAfterBattle
	dw Route15EndBattleText1 ; TextEndBattle
	dw Route15EndBattleText1 ; TextEndBattle

Route15TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_ROUTE_15_TRAINER_1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_15_TRAINER_1
	dw Route15BattleText2 ; TextBeforeBattle
	dw Route15AfterBattleText2 ; TextAfterBattle
	dw Route15EndBattleText2 ; TextEndBattle
	dw Route15EndBattleText2 ; TextEndBattle

Route15TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_ROUTE_15_TRAINER_2
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_15_TRAINER_2
	dw Route15BattleText3 ; TextBeforeBattle
	dw Route15AfterBattleText3 ; TextAfterBattle
	dw Route15EndBattleText3 ; TextEndBattle
	dw Route15EndBattleText3 ; TextEndBattle

Route15TrainerHeader3:
	dbEventFlagBit EVENT_BEAT_ROUTE_15_TRAINER_3
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_15_TRAINER_3
	dw Route15BattleText4 ; TextBeforeBattle
	dw Route15AfterBattleText4 ; TextAfterBattle
	dw Route15EndBattleText4 ; TextEndBattle
	dw Route15EndBattleText4 ; TextEndBattle

Route15TrainerHeader4:
	dbEventFlagBit EVENT_BEAT_ROUTE_15_TRAINER_4
	db ($2 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_15_TRAINER_4
	dw Route15BattleText5 ; TextBeforeBattle
	dw Route15AfterBattleText5 ; TextAfterBattle
	dw Route15EndBattleText5 ; TextEndBattle
	dw Route15EndBattleText5 ; TextEndBattle

Route15TrainerHeader5:
	dbEventFlagBit EVENT_BEAT_ROUTE_15_TRAINER_5
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_15_TRAINER_5
	dw Route15BattleText6 ; TextBeforeBattle
	dw Route15AfterBattleText6 ; TextAfterBattle
	dw Route15EndBattleText6 ; TextEndBattle
	dw Route15EndBattleText6 ; TextEndBattle

Route15TrainerHeader6:
	dbEventFlagBit EVENT_BEAT_ROUTE_15_TRAINER_6
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_15_TRAINER_6
	dw Route15BattleText7 ; TextBeforeBattle
	dw Route15AfterBattleText7 ; TextAfterBattle
	dw Route15EndBattleText7 ; TextEndBattle
	dw Route15EndBattleText7 ; TextEndBattle

Route15TrainerHeader7:
	dbEventFlagBit EVENT_BEAT_ROUTE_15_TRAINER_7, 1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_15_TRAINER_7, 1
	dw Route15BattleText8 ; TextBeforeBattle
	dw Route15AfterBattleText8 ; TextAfterBattle
	dw Route15EndBattleText8 ; TextEndBattle
	dw Route15EndBattleText8 ; TextEndBattle

Route15TrainerHeader8:
	dbEventFlagBit EVENT_BEAT_ROUTE_15_TRAINER_8, 1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_15_TRAINER_8, 1
	dw Route15BattleText9 ; TextBeforeBattle
	dw Route15AfterBattleText9 ; TextAfterBattle
	dw Route15EndBattleText9 ; TextEndBattle
	dw Route15EndBattleText9 ; TextEndBattle

Route15TrainerHeader9:
	dbEventFlagBit EVENT_BEAT_ROUTE_15_TRAINER_9, 1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROUTE_15_TRAINER_9, 1
	dw Route15BattleText10 ; TextBeforeBattle
	dw Route15AfterBattleText10 ; TextAfterBattle
	dw Route15EndBattleText10 ; TextEndBattle
	dw Route15EndBattleText10 ; TextEndBattle

	db $ff

Route15Text1:
	asmtext
	ld hl, Route15TrainerHeader0
	jr Route15TalkToTrainer

Route15Text2:
	asmtext
	ld hl, Route15TrainerHeader1
	jr Route15TalkToTrainer

Route15Text3:
	asmtext
	ld hl, Route15TrainerHeader2
	jr Route15TalkToTrainer

Route15Text4:
	asmtext
	ld hl, Route15TrainerHeader3
	jr Route15TalkToTrainer

Route15Text5:
	asmtext
	ld hl, Route15TrainerHeader4
	jr Route15TalkToTrainer

Route15Text6:
	asmtext
	ld hl, Route15TrainerHeader5
	jr Route15TalkToTrainer

Route15Text7:
	asmtext
	ld hl, Route15TrainerHeader6
	jr Route15TalkToTrainer

Route15Text8:
	asmtext
	ld hl, Route15TrainerHeader7
	jr Route15TalkToTrainer

Route15Text9:
	asmtext
	ld hl, Route15TrainerHeader8
	jr Route15TalkToTrainer

Route15Text10:
	asmtext
	ld hl, Route15TrainerHeader9
Route15TalkToTrainer:
	call TalkToTrainer
	jp TextScriptEnd

Route15BattleText1:
	fartext _Route15BattleText1
	done

Route15EndBattleText1:
	fartext _Route15EndBattleText1
	done

Route15AfterBattleText1:
	fartext _Route15AfterBattleText1
	done

Route15BattleText2:
	fartext _Route15BattleText2
	done

Route15EndBattleText2:
	fartext _Route15EndBattleText2
	done

Route15AfterBattleText2:
	fartext _Route15AfterBattleText2
	done

Route15BattleText3:
	fartext _Route15BattleText3
	done

Route15EndBattleText3:
	fartext _Route15EndBattleText3
	done

Route15AfterBattleText3:
	fartext _Route15AfterBattleText3
	done

Route15BattleText4:
	fartext _Route15BattleText4
	done

Route15EndBattleText4:
	fartext _Route15EndBattleText4
	done

Route15AfterBattleText4:
	fartext _Route15AfterBattleText4
	done

Route15BattleText5:
	fartext _Route15BattleText5
	done

Route15EndBattleText5:
	fartext _Route15EndBattleText5
	done

Route15AfterBattleText5:
	fartext _Route15AfterBattleText5
	done

Route15BattleText6:
	fartext _Route15BattleText6
	done

Route15EndBattleText6:
	fartext _Route15EndBattleText6
	done

Route15AfterBattleText6:
	fartext _Route15AfterBattleText6
	done

Route15BattleText7:
	fartext _Route15BattleText7
	done

Route15EndBattleText7:
	fartext _Route15EndBattleText7
	done

Route15AfterBattleText7:
	fartext _Route15AfterBattleText7
	done

Route15BattleText8:
	fartext _Route15BattleText8
	done

Route15EndBattleText8:
	fartext _Route15EndBattleText8
	done

Route15AfterBattleText8:
	fartext _Route15AfterBattleText8
	done

Route15BattleText9:
	fartext _Route15BattleText9
	done

Route15EndBattleText9:
	fartext _Route15EndBattleText9
	done

Route15AfterBattleText9:
	fartext _Route15AfterBattleText9
	done

Route15BattleText10:
	fartext _Route15BattleText10
	done

Route15EndBattleText10:
	fartext _Route15EndBattleText10
	done

Route15AfterBattleText10:
	fartext _Route15AfterBattleText10
	done

Route15Text12:
	fartext _Route15Text12
	done
