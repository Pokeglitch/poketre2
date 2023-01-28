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
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route3BattleText1 ; TextBeforeBattle
	dw Route3AfterBattleText1 ; TextAfterBattle
	dw Route3EndBattleText1 ; TextEndBattle
	dw Route3EndBattleText1 ; TextEndBattle

Route3TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route3BattleText2 ; TextBeforeBattle
	dw Route3AfterBattleText2 ; TextAfterBattle
	dw Route3EndBattleText2 ; TextEndBattle
	dw Route3EndBattleText2 ; TextEndBattle

Route3TrainerHeader2:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route3BattleText3 ; TextBeforeBattle
	dw Route3AfterBattleText3 ; TextAfterBattle
	dw Route3EndBattleText3 ; TextEndBattle
	dw Route3EndBattleText3 ; TextEndBattle

Route3TrainerHeader3:
	db 0 ; former event flag bit index
	db ($1 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route3BattleText4 ; TextBeforeBattle
	dw Route3AfterBattleText4 ; TextAfterBattle
	dw Route3EndBattleText4 ; TextEndBattle
	dw Route3EndBattleText4 ; TextEndBattle

Route3TrainerHeader4:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route3BattleText5 ; TextBeforeBattle
	dw Route3AfterBattleText5 ; TextAfterBattle
	dw Route3EndBattleText5 ; TextEndBattle
	dw Route3EndBattleText5 ; TextEndBattle

Route3TrainerHeader5:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route3BattleText6 ; TextBeforeBattle
	dw Route3AfterBattleText6 ; TextAfterBattle
	dw Route3EndBattleText6 ; TextEndBattle
	dw Route3EndBattleText6 ; TextEndBattle

Route3TrainerHeader6:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route3BattleText7 ; TextBeforeBattle
	dw Route3AfterBattleText7 ; TextAfterBattle
	dw Route3EndBattleText7 ; TextEndBattle
	dw Route3EndBattleText7 ; TextEndBattle

Route3TrainerHeader7:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route3BattleText8 ; TextBeforeBattle
	dw Route3AfterBattleText8 ; TextAfterBattle
	dw Route3EndBattleText8 ; TextEndBattle
	dw Route3EndBattleText8 ; TextEndBattle

	db $ff

Route3Text1:
	fartext _Route3Text1
	done

Route3Text2:
	asmtext
	ld hl, Route3TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText1:
	fartext _Route3BattleText1
	done

Route3EndBattleText1:
	fartext _Route3EndBattleText1
	done

Route3AfterBattleText1:
	fartext _Route3AfterBattleText1
	done

Route3Text3:
	asmtext
	ld hl, Route3TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText2:
	fartext _Route3BattleText2
	done

Route3EndBattleText2:
	fartext _Route3EndBattleText2
	done

Route3AfterBattleText2:
	fartext _Route3AfterBattleText2
	done

Route3Text4:
	asmtext
	ld hl, Route3TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText3:
	fartext _Route3BattleText3
	done

Route3EndBattleText3:
	fartext _Route3EndBattleText3
	done

Route3AfterBattleText3:
	fartext _Route3AfterBattleText3
	done

Route3Text5:
	asmtext
	ld hl, Route3TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText4:
	fartext _Route3BattleText4
	done

Route3EndBattleText4:
	fartext _Route3EndBattleText4
	done

Route3AfterBattleText4:
	fartext _Route3AfterBattleText4
	done

Route3Text6:
	asmtext
	ld hl, Route3TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText5:
	fartext _Route3BattleText5
	done

Route3EndBattleText5:
	fartext _Route3EndBattleText5
	done

Route3AfterBattleText5:
	fartext _Route3AfterBattleText5
	done

Route3Text7:
	asmtext
	ld hl, Route3TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText6:
	fartext _Route3BattleText6
	done

Route3EndBattleText6:
	fartext _Route3EndBattleText6
	done

Route3AfterBattleText6:
	fartext _Route3AfterBattleText6
	done

Route3Text8:
	asmtext
	ld hl, Route3TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText7:
	fartext _Route3BattleText7
	done

Route3EndBattleText7:
	fartext _Route3EndBattleText7
	done

Route3AfterBattleText7:
	fartext _Route3AfterBattleText7
	done

Route3Text9:
	asmtext
	ld hl, Route3TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

Route3BattleText8:
	fartext _Route3BattleText8
	done

Route3EndBattleText8:
	fartext _Route3EndBattleText8
	done

Route3AfterBattleText8:
	fartext _Route3AfterBattleText8
	done

Route3Text10:
	fartext _Route3Text10
	done
