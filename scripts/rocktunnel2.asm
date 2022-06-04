RockTunnel2Script:
	call EnableAutoTextBoxDrawing
	ld hl, RockTunnel2TrainerHeader0
	ld de, RockTunnel2ScriptPointers
	ld a, [wRockTunnel2CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRockTunnel2CurScript], a
	ret

RockTunnel2ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

RockTunnel2TextPointers:
	dw RockTunnel2Text1
	dw RockTunnel2Text2
	dw RockTunnel2Text3
	dw RockTunnel2Text4
	dw RockTunnel2Text5
	dw RockTunnel2Text6
	dw RockTunnel2Text7
	dw RockTunnel2Text8

RockTunnel2TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_0
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_0
	dw RockTunnel2BattleText2 ; TextBeforeBattle
	dw RockTunnel2AfterBattleText2 ; TextAfterBattle
	dw RockTunnel2EndBattleText2 ; TextEndBattle
	dw RockTunnel2EndBattleText2 ; TextEndBattle

RockTunnel2TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_1
	dw RockTunnel2BattleText3 ; TextBeforeBattle
	dw RockTunnel2AfterBattleText3 ; TextAfterBattle
	dw RockTunnel2EndBattleText3 ; TextEndBattle
	dw RockTunnel2EndBattleText3 ; TextEndBattle

RockTunnel2TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_2
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_2
	dw RockTunnel2BattleText4 ; TextBeforeBattle
	dw RockTunnel2AfterBattleText4 ; TextAfterBattle
	dw RockTunnel2EndBattleText4 ; TextEndBattle
	dw RockTunnel2EndBattleText4 ; TextEndBattle

RockTunnel2TrainerHeader3:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_3
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_3
	dw RockTunnel2BattleText5 ; TextBeforeBattle
	dw RockTunnel2AfterBattleText5 ; TextAfterBattle
	dw RockTunnel2EndBattleText5 ; TextEndBattle
	dw RockTunnel2EndBattleText5 ; TextEndBattle

RockTunnel2TrainerHeader4:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_4
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_4
	dw RockTunnel2BattleText6 ; TextBeforeBattle
	dw RockTunnel2AfterBattleText6 ; TextAfterBattle
	dw RockTunnel2EndBattleText6 ; TextEndBattle
	dw RockTunnel2EndBattleText6 ; TextEndBattle

RockTunnel2TrainerHeader5:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_5
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_5
	dw RockTunnel2BattleText7 ; TextBeforeBattle
	dw RockTunnel2AfterBattleText7 ; TextAfterBattle
	dw RockTunnel2EndBattleText7 ; TextEndBattle
	dw RockTunnel2EndBattleText7 ; TextEndBattle

RockTunnel2TrainerHeader6:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_6
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_6
	dw RockTunnel2BattleText8 ; TextBeforeBattle
	dw RockTunnel2AfterBattleText8 ; TextAfterBattle
	dw RockTunnel2EndBattleText8 ; TextEndBattle
	dw RockTunnel2EndBattleText8 ; TextEndBattle

RockTunnel2TrainerHeader7:
	dbEventFlagBit EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_7, 1
	db ($3 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_ROCK_TUNNEL_2_TRAINER_7, 1
	dw RockTunnel2BattleText9 ; TextBeforeBattle
	dw RockTunnel2AfterBattleText9 ; TextAfterBattle
	dw RockTunnel2EndBattleText9 ; TextEndBattle
	dw RockTunnel2EndBattleText9 ; TextEndBattle

	db $ff

RockTunnel2Text1:
	asmtext
	ld hl, RockTunnel2TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

RockTunnel2Text2:
	asmtext
	ld hl, RockTunnel2TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

RockTunnel2Text3:
	asmtext
	ld hl, RockTunnel2TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

RockTunnel2Text4:
	asmtext
	ld hl, RockTunnel2TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

RockTunnel2Text5:
	asmtext
	ld hl, RockTunnel2TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

RockTunnel2Text6:
	asmtext
	ld hl, RockTunnel2TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

RockTunnel2Text7:
	asmtext
	ld hl, RockTunnel2TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

RockTunnel2Text8:
	asmtext
	ld hl, RockTunnel2TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

RockTunnel2BattleText2:
	fartext _RockTunnel2BattleText2
	done

RockTunnel2EndBattleText2:
	fartext _RockTunnel2EndBattleText2
	done

RockTunnel2AfterBattleText2:
	fartext _RockTunnel2AfterBattleText2
	done

RockTunnel2BattleText3:
	fartext _RockTunnel2BattleText3
	done

RockTunnel2EndBattleText3:
	fartext _RockTunnel2EndBattleText3
	done

RockTunnel2AfterBattleText3:
	fartext _RockTunnel2AfterBattleText3
	done

RockTunnel2BattleText4:
	fartext _RockTunnel2BattleText4
	done

RockTunnel2EndBattleText4:
	fartext _RockTunnel2EndBattleText4
	done

RockTunnel2AfterBattleText4:
	fartext _RockTunnel2AfterBattleText4
	done

RockTunnel2BattleText5:
	fartext _RockTunnel2BattleText5
	done

RockTunnel2EndBattleText5:
	fartext _RockTunnel2EndBattleText5
	done

RockTunnel2AfterBattleText5:
	fartext _RockTunnel2AfterBattleText5
	done

RockTunnel2BattleText6:
	fartext _RockTunnel2BattleText6
	done

RockTunnel2EndBattleText6:
	fartext _RockTunnel2EndBattleText6
	done

RockTunnel2AfterBattleText6:
	fartext _RockTunnel2AfterBattleText6
	done

RockTunnel2BattleText7:
	fartext _RockTunnel2BattleText7
	done

RockTunnel2EndBattleText7:
	fartext _RockTunnel2EndBattleText7
	done

RockTunnel2AfterBattleText7:
	fartext _RockTunnel2AfterBattleText7
	done

RockTunnel2BattleText8:
	fartext _RockTunnel2BattleText8
	done

RockTunnel2EndBattleText8:
	fartext _RockTunnel2EndBattleText8
	done

RockTunnel2AfterBattleText8:
	fartext _RockTunnel2AfterBattleText8
	done

RockTunnel2BattleText9:
	fartext _RockTunnel2BattleText9
	done

RockTunnel2EndBattleText9:
	fartext _RockTunnel2EndBattleText9
	done

RockTunnel2AfterBattleText9:
	fartext _RockTunnel2AfterBattleText9
	done
