Route11Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route11TrainerHeader0
	ld de, Route11ScriptPointers
	ld a, [wRoute11CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute11CurScript], a
	ret

Route11ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route11TextPointers:
	dw Route11Text1
	dw Route11Text2
	dw Route11Text3
	dw Route11Text4
	dw Route11Text5
	dw Route11Text6
	dw Route11Text7
	dw Route11Text8
	dw Route11Text9
	dw Route11Text10
	dw Route11Text11

Route11TrainerHeader0:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route11BattleText1 ; TextBeforeBattle
	dw Route11AfterBattleText1 ; TextAfterBattle
	dw Route11EndBattleText1 ; TextEndBattle
	dw Route11EndBattleText1 ; TextEndBattle

Route11TrainerHeader1:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route11BattleText2 ; TextBeforeBattle
	dw Route11AfterBattleText2 ; TextAfterBattle
	dw Route11EndBattleText2 ; TextEndBattle
	dw Route11EndBattleText2 ; TextEndBattle

Route11TrainerHeader2:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route11BattleText3 ; TextBeforeBattle
	dw Route11AfterBattleText3 ; TextAfterBattle
	dw Route11EndBattleText3 ; TextEndBattle
	dw Route11EndBattleText3 ; TextEndBattle

Route11TrainerHeader3:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route11BattleText4 ; TextBeforeBattle
	dw Route11AfterBattleText4 ; TextAfterBattle
	dw Route11EndBattleText4 ; TextEndBattle
	dw Route11EndBattleText4 ; TextEndBattle

Route11TrainerHeader4:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route11BattleText5 ; TextBeforeBattle
	dw Route11AfterBattleText5 ; TextAfterBattle
	dw Route11EndBattleText5 ; TextEndBattle
	dw Route11EndBattleText5 ; TextEndBattle

Route11TrainerHeader5:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route11BattleText6 ; TextBeforeBattle
	dw Route11AfterBattleText6 ; TextAfterBattle
	dw Route11EndBattleText6 ; TextEndBattle
	dw Route11EndBattleText6 ; TextEndBattle

Route11TrainerHeader6:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route11BattleText7 ; TextBeforeBattle
	dw Route11AfterBattleText7 ; TextAfterBattle
	dw Route11EndBattleText7 ; TextEndBattle
	dw Route11EndBattleText7 ; TextEndBattle

Route11TrainerHeader7:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route11BattleText8 ; TextBeforeBattle
	dw Route11AfterBattleText8 ; TextAfterBattle
	dw Route11EndBattleText8 ; TextEndBattle
	dw Route11EndBattleText8 ; TextEndBattle

Route11TrainerHeader8:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route11BattleText9 ; TextBeforeBattle
	dw Route11AfterBattleText9 ; TextAfterBattle
	dw Route11EndBattleText9 ; TextEndBattle
	dw Route11EndBattleText9 ; TextEndBattle

Route11TrainerHeader9:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route11BattleText10 ; TextBeforeBattle
	dw Route11AfterBattleText10 ; TextAfterBattle
	dw Route11EndBattleText10 ; TextEndBattle
	dw Route11EndBattleText10 ; TextEndBattle

	db $ff

Route11Text1:
	asmtext
	ld hl, Route11TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route11BattleText1:
	fartext _Route11BattleText1
	done

Route11EndBattleText1:
	fartext _Route11EndBattleText1
	done

Route11AfterBattleText1:
	fartext _Route11AfterBattleText1
	done

Route11Text2:
	asmtext
	ld hl, Route11TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route11BattleText2:
	fartext _Route11BattleText2
	done

Route11EndBattleText2:
	fartext _Route11EndBattleText2
	done

Route11AfterBattleText2:
	fartext _Route11AfterBattleText2
	done

Route11Text3:
	asmtext
	ld hl, Route11TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route11BattleText3:
	fartext _Route11BattleText3
	done

Route11EndBattleText3:
	fartext _Route11EndBattleText3
	done

Route11AfterBattleText3:
	fartext _Route11AfterBattleText3
	done

Route11Text4:
	asmtext
	ld hl, Route11TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route11BattleText4:
	fartext _Route11BattleText4
	done

Route11EndBattleText4:
	fartext _Route11EndBattleText4
	done

Route11AfterBattleText4:
	fartext _Route11AfterBattleText4
	done

Route11Text5:
	asmtext
	ld hl, Route11TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route11BattleText5:
	fartext _Route11BattleText5
	done

Route11EndBattleText5:
	fartext _Route11EndBattleText5
	done

Route11AfterBattleText5:
	fartext _Route11AfterBattleText5
	done

Route11Text6:
	asmtext
	ld hl, Route11TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route11BattleText6:
	fartext _Route11BattleText6
	done

Route11EndBattleText6:
	fartext _Route11EndBattleText6
	done

Route11AfterBattleText6:
	fartext _Route11AfterBattleText6
	done

Route11Text7:
	asmtext
	ld hl, Route11TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

Route11BattleText7:
	fartext _Route11BattleText7
	done

Route11EndBattleText7:
	fartext _Route11EndBattleText7
	done

Route11AfterBattleText7:
	fartext _Route11AfterBattleText7
	done

Route11Text8:
	asmtext
	ld hl, Route11TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

Route11BattleText8:
	fartext _Route11BattleText8
	done

Route11EndBattleText8:
	fartext _Route11EndBattleText8
	done

Route11AfterBattleText8:
	fartext _Route11AfterBattleText8
	done

Route11Text9:
	asmtext
	ld hl, Route11TrainerHeader8
	call TalkToTrainer
	jp TextScriptEnd

Route11BattleText9:
	fartext _Route11BattleText9
	done

Route11EndBattleText9:
	fartext _Route11EndBattleText9
	done

Route11AfterBattleText9:
	fartext _Route11AfterBattleText9
	done

Route11Text10:
	asmtext
	ld hl, Route11TrainerHeader9
	call TalkToTrainer
	jp TextScriptEnd

Route11BattleText10:
	fartext _Route11BattleText10
	done

Route11EndBattleText10:
	fartext _Route11EndBattleText10
	done

Route11AfterBattleText10:
	fartext _Route11AfterBattleText10
	done

Route11Text11:
	fartext _Route11Text11
	done
