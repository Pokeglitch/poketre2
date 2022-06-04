SSAnne5Script:
	call EnableAutoTextBoxDrawing
	ld hl, SSAnne5TrainerHeader0
	ld de, SSAnne5ScriptPointers
	ld a, [wSSAnne5CurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSAnne5CurScript], a
	ret

SSAnne5ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

SSAnne5TextPointers:
	dw SSAnne5Text1
	dw SSAnne5Text2
	dw SSAnne5Text3
	dw SSAnne5Text4
	dw SSAnne5Text5

SSAnne5TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_SS_ANNE_5_TRAINER_0
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SS_ANNE_5_TRAINER_0
	dw SSAnne5BattleText1 ; TextBeforeBattle
	dw SSAnne5AfterBattleText1 ; TextAfterBattle
	dw SSAnne5EndBattleText1 ; TextEndBattle
	dw SSAnne5EndBattleText1 ; TextEndBattle

SSAnne5TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_SS_ANNE_5_TRAINER_1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_SS_ANNE_5_TRAINER_1
	dw SSAnne5BattleText2 ; TextBeforeBattle
	dw SSAnne5AfterBattleText2 ; TextAfterBattle
	dw SSAnne5EndBattleText2 ; TextEndBattle
	dw SSAnne5EndBattleText2 ; TextEndBattle

	db $ff

SSAnne5Text1:
	text ""
	fartext _SSAnne5Text1
	done

SSAnne5Text2:
	text ""
	fartext _SSAnne5Text2
	done

SSAnne5Text3:
	text ""
	fartext _SSAnne5Text3
	done

SSAnne5Text4:
	text ""
	asmtext
	ld hl, SSAnne5TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSAnne5BattleText1:
	text ""
	fartext _SSAnne5BattleText1
	done

SSAnne5EndBattleText1:
	text ""
	fartext _SSAnne5EndBattleText1
	done

SSAnne5AfterBattleText1:
	text ""
	fartext _SSAnne5AfterBattleText1
	done

SSAnne5Text5:
	text ""
	asmtext
	ld hl, SSAnne5TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSAnne5BattleText2:
	text ""
	fartext _SSAnne5BattleText2
	done

SSAnne5EndBattleText2:
	text ""
	fartext _SSAnne5EndBattleText2
	done

SSAnne5AfterBattleText2:
	text ""
	fartext _SSAnne5AfterBattleText2
	done
