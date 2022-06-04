RockTunnel1Script:
	call EnableAutoTextBoxDrawing
	ld hl, RockTunnel1TrainerHeader0
	ld de, RockTunnel1ScriptPointers
	ld a, [wRockTunnel1CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRockTunnel1CurScript], a
	ret

RockTunnel1ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

RockTunnel1TextPointers:
	dw RockTunnel1Text1
	dw RockTunnel1Text2
	dw RockTunnel1Text3
	dw RockTunnel1Text4
	dw RockTunnel1Text5
	dw RockTunnel1Text6
	dw RockTunnel1Text7
	dw RockTunnel1Text8

RockTunnel1TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_0
	dw RockTunnel1BattleText1 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText1 ; TextAfterBattle
	dw RockTunnel1EndBattleText1 ; TextEndBattle
	dw RockTunnel1EndBattleText1 ; TextEndBattle

RockTunnel1TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_1
	dw RockTunnel1BattleText2 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText2 ; TextAfterBattle
	dw RockTunnel1EndBattleText2 ; TextEndBattle
	dw RockTunnel1EndBattleText2 ; TextEndBattle

RockTunnel1TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_2
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_2
	dw RockTunnel1BattleText3 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText3 ; TextAfterBattle
	dw RockTunnel1EndBattleText3 ; TextEndBattle
	dw RockTunnel1EndBattleText3 ; TextEndBattle

RockTunnel1TrainerHeader3:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_3
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_3
	dw RockTunnel1BattleText4 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText4 ; TextAfterBattle
	dw RockTunnel1EndBattleText4 ; TextEndBattle
	dw RockTunnel1EndBattleText4 ; TextEndBattle

RockTunnel1TrainerHeader4:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_4
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_4
	dw RockTunnel1BattleText5 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText5 ; TextAfterBattle
	dw RockTunnel1EndBattleText5 ; TextEndBattle
	dw RockTunnel1EndBattleText5 ; TextEndBattle

RockTunnel1TrainerHeader5:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_5
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_5
	dw RockTunnel1BattleText6 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText6 ; TextAfterBattle
	dw RockTunnel1EndBattleText6 ; TextEndBattle
	dw RockTunnel1EndBattleText6 ; TextEndBattle

RockTunnel1TrainerHeader6:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_6
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_1_TRAINER_6
	dw RockTunnel1BattleText7 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText7 ; TextAfterBattle
	dw RockTunnel1EndBattleText7 ; TextEndBattle
	dw RockTunnel1EndBattleText7 ; TextEndBattle

	db $ff

RockTunnel1Text1:
	text ""
	asmtext
	ld hl, RockTunnel1TrainerHeader0
	jr RockTunnel1TalkToTrainer

RockTunnel1Text2:
	text ""
	asmtext
	ld hl, RockTunnel1TrainerHeader1
	jr RockTunnel1TalkToTrainer

RockTunnel1Text3:
	text ""
	asmtext
	ld hl, RockTunnel1TrainerHeader2
	jr RockTunnel1TalkToTrainer

RockTunnel1Text4:
	text ""
	asmtext
	ld hl, RockTunnel1TrainerHeader3
	jr RockTunnel1TalkToTrainer

RockTunnel1Text5:
	text ""
	asmtext
	ld hl, RockTunnel1TrainerHeader4
	jr RockTunnel1TalkToTrainer

RockTunnel1Text6:
	text ""
	asmtext
	ld hl, RockTunnel1TrainerHeader5
	jr RockTunnel1TalkToTrainer

RockTunnel1Text7:
	text ""
	asmtext
	ld hl, RockTunnel1TrainerHeader6
RockTunnel1TalkToTrainer:
	call TalkToTrainer
	jp TextScriptEnd

RockTunnel1BattleText1:
	text ""
	fartext _RockTunnel1BattleText1
	done

RockTunnel1EndBattleText1:
	text ""
	fartext _RockTunnel1EndBattleText1
	done

RockTunnel1AfterBattleText1:
	text ""
	fartext _RockTunnel1AfterBattleText1
	done

RockTunnel1BattleText2:
	text ""
	fartext _RockTunnel1BattleText2
	done

RockTunnel1EndBattleText2:
	text ""
	fartext _RockTunnel1EndBattleText2
	done

RockTunnel1AfterBattleText2:
	text ""
	fartext _RockTunnel1AfterBattleText2
	done

RockTunnel1BattleText3:
	text ""
	fartext _RockTunnel1BattleText3
	done

RockTunnel1EndBattleText3:
	text ""
	fartext _RockTunnel1EndBattleText3
	done

RockTunnel1AfterBattleText3:
	text ""
	fartext _RockTunnel1AfterBattleText3
	done

RockTunnel1BattleText4:
	text ""
	fartext _RockTunnel1BattleText4
	done

RockTunnel1EndBattleText4:
	text ""
	fartext _RockTunnel1EndBattleText4
	done

RockTunnel1AfterBattleText4:
	text ""
	fartext _RockTunnel1AfterBattleText4
	done

RockTunnel1BattleText5:
	text ""
	fartext _RockTunnel1BattleText5
	done

RockTunnel1EndBattleText5:
	text ""
	fartext _RockTunnel1EndBattleText5
	done

RockTunnel1AfterBattleText5:
	text ""
	fartext _RockTunnel1AfterBattleText5
	done

RockTunnel1BattleText6:
	text ""
	fartext _RockTunnel1BattleText6
	done

RockTunnel1EndBattleText6:
	text ""
	fartext _RockTunnel1EndBattleText6
	done

RockTunnel1AfterBattleText6:
	text ""
	fartext _RockTunnel1AfterBattleText6
	done

RockTunnel1BattleText7:
	text ""
	fartext _RockTunnel1BattleText7
	done

RockTunnel1EndBattleText7:
	text ""
	fartext _RockTunnel1EndBattleText7
	done

RockTunnel1AfterBattleText7:
	text ""
	fartext _RockTunnel1AfterBattleText7
	done

RockTunnel1Text8:
	text ""
	fartext _RockTunnel1Text8
	done
