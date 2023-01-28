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
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw RockTunnel1BattleText1 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText1 ; TextAfterBattle
	dw RockTunnel1EndBattleText1 ; TextEndBattle
	dw RockTunnel1EndBattleText1 ; TextEndBattle

RockTunnel1TrainerHeader1:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw RockTunnel1BattleText2 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText2 ; TextAfterBattle
	dw RockTunnel1EndBattleText2 ; TextEndBattle
	dw RockTunnel1EndBattleText2 ; TextEndBattle

RockTunnel1TrainerHeader2:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw RockTunnel1BattleText3 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText3 ; TextAfterBattle
	dw RockTunnel1EndBattleText3 ; TextEndBattle
	dw RockTunnel1EndBattleText3 ; TextEndBattle

RockTunnel1TrainerHeader3:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw RockTunnel1BattleText4 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText4 ; TextAfterBattle
	dw RockTunnel1EndBattleText4 ; TextEndBattle
	dw RockTunnel1EndBattleText4 ; TextEndBattle

RockTunnel1TrainerHeader4:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw RockTunnel1BattleText5 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText5 ; TextAfterBattle
	dw RockTunnel1EndBattleText5 ; TextEndBattle
	dw RockTunnel1EndBattleText5 ; TextEndBattle

RockTunnel1TrainerHeader5:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw RockTunnel1BattleText6 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText6 ; TextAfterBattle
	dw RockTunnel1EndBattleText6 ; TextEndBattle
	dw RockTunnel1EndBattleText6 ; TextEndBattle

RockTunnel1TrainerHeader6:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw RockTunnel1BattleText7 ; TextBeforeBattle
	dw RockTunnel1AfterBattleText7 ; TextAfterBattle
	dw RockTunnel1EndBattleText7 ; TextEndBattle
	dw RockTunnel1EndBattleText7 ; TextEndBattle

	db $ff

RockTunnel1Text1:
	asmtext
	ld hl, RockTunnel1TrainerHeader0
	jr RockTunnel1TalkToTrainer

RockTunnel1Text2:
	asmtext
	ld hl, RockTunnel1TrainerHeader1
	jr RockTunnel1TalkToTrainer

RockTunnel1Text3:
	asmtext
	ld hl, RockTunnel1TrainerHeader2
	jr RockTunnel1TalkToTrainer

RockTunnel1Text4:
	asmtext
	ld hl, RockTunnel1TrainerHeader3
	jr RockTunnel1TalkToTrainer

RockTunnel1Text5:
	asmtext
	ld hl, RockTunnel1TrainerHeader4
	jr RockTunnel1TalkToTrainer

RockTunnel1Text6:
	asmtext
	ld hl, RockTunnel1TrainerHeader5
	jr RockTunnel1TalkToTrainer

RockTunnel1Text7:
	asmtext
	ld hl, RockTunnel1TrainerHeader6
RockTunnel1TalkToTrainer:
	call TalkToTrainer
	jp TextScriptEnd

RockTunnel1BattleText1:
	fartext _RockTunnel1BattleText1
	done

RockTunnel1EndBattleText1:
	fartext _RockTunnel1EndBattleText1
	done

RockTunnel1AfterBattleText1:
	fartext _RockTunnel1AfterBattleText1
	done

RockTunnel1BattleText2:
	fartext _RockTunnel1BattleText2
	done

RockTunnel1EndBattleText2:
	fartext _RockTunnel1EndBattleText2
	done

RockTunnel1AfterBattleText2:
	fartext _RockTunnel1AfterBattleText2
	done

RockTunnel1BattleText3:
	fartext _RockTunnel1BattleText3
	done

RockTunnel1EndBattleText3:
	fartext _RockTunnel1EndBattleText3
	done

RockTunnel1AfterBattleText3:
	fartext _RockTunnel1AfterBattleText3
	done

RockTunnel1BattleText4:
	fartext _RockTunnel1BattleText4
	done

RockTunnel1EndBattleText4:
	fartext _RockTunnel1EndBattleText4
	done

RockTunnel1AfterBattleText4:
	fartext _RockTunnel1AfterBattleText4
	done

RockTunnel1BattleText5:
	fartext _RockTunnel1BattleText5
	done

RockTunnel1EndBattleText5:
	fartext _RockTunnel1EndBattleText5
	done

RockTunnel1AfterBattleText5:
	fartext _RockTunnel1AfterBattleText5
	done

RockTunnel1BattleText6:
	fartext _RockTunnel1BattleText6
	done

RockTunnel1EndBattleText6:
	fartext _RockTunnel1EndBattleText6
	done

RockTunnel1AfterBattleText6:
	fartext _RockTunnel1AfterBattleText6
	done

RockTunnel1BattleText7:
	fartext _RockTunnel1BattleText7
	done

RockTunnel1EndBattleText7:
	fartext _RockTunnel1EndBattleText7
	done

RockTunnel1AfterBattleText7:
	fartext _RockTunnel1AfterBattleText7
	done

RockTunnel1Text8:
	fartext _RockTunnel1Text8
	done
