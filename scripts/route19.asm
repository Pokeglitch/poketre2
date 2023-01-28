Route19Script:
	call EnableAutoTextBoxDrawing
	ld hl, Route19TrainerHeader0
	ld de, Route19ScriptPointers
	ld a, [wRoute19CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute19CurScript], a
	ret

Route19ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route19TextPointers:
	dw Route19Text1
	dw Route19Text2
	dw Route19Text3
	dw Route19Text4
	dw Route19Text5
	dw Route19Text6
	dw Route19Text7
	dw Route19Text8
	dw Route19Text9
	dw Route19Text10
	dw Route19Text11

Route19TrainerHeader0:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route19BattleText1 ; TextBeforeBattle
	dw Route19AfterBattleText1 ; TextAfterBattle
	dw Route19EndBattleText1 ; TextEndBattle
	dw Route19EndBattleText1 ; TextEndBattle

Route19TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route19BattleText2 ; TextBeforeBattle
	dw Route19AfterBattleText2 ; TextAfterBattle
	dw Route19EndBattleText2 ; TextEndBattle
	dw Route19EndBattleText2 ; TextEndBattle

Route19TrainerHeader2:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route19BattleText3 ; TextBeforeBattle
	dw Route19AfterBattleText3 ; TextAfterBattle
	dw Route19EndBattleText3 ; TextEndBattle
	dw Route19EndBattleText3 ; TextEndBattle

Route19TrainerHeader3:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route19BattleText4 ; TextBeforeBattle
	dw Route19AfterBattleText4 ; TextAfterBattle
	dw Route19EndBattleText4 ; TextEndBattle
	dw Route19EndBattleText4 ; TextEndBattle

Route19TrainerHeader4:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route19BattleText5 ; TextBeforeBattle
	dw Route19AfterBattleText5 ; TextAfterBattle
	dw Route19EndBattleText5 ; TextEndBattle
	dw Route19EndBattleText5 ; TextEndBattle

Route19TrainerHeader5:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route19BattleText6 ; TextBeforeBattle
	dw Route19AfterBattleText6 ; TextAfterBattle
	dw Route19EndBattleText6 ; TextEndBattle
	dw Route19EndBattleText6 ; TextEndBattle

Route19TrainerHeader6:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route19BattleText7 ; TextBeforeBattle
	dw Route19AfterBattleText7 ; TextAfterBattle
	dw Route19EndBattleText7 ; TextEndBattle
	dw Route19EndBattleText7 ; TextEndBattle

Route19TrainerHeader7:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route19BattleText8 ; TextBeforeBattle
	dw Route19AfterBattleText8 ; TextAfterBattle
	dw Route19EndBattleText8 ; TextEndBattle
	dw Route19EndBattleText8 ; TextEndBattle

Route19TrainerHeader8:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route19BattleText9 ; TextBeforeBattle
	dw Route19AfterBattleText9 ; TextAfterBattle
	dw Route19EndBattleText9 ; TextEndBattle
	dw Route19EndBattleText9 ; TextEndBattle

Route19TrainerHeader9:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route19BattleText10 ; TextBeforeBattle
	dw Route19AfterBattleText10 ; TextAfterBattle
	dw Route19EndBattleText10 ; TextEndBattle
	dw Route19EndBattleText10 ; TextEndBattle

	db $ff

Route19Text1:
	asmtext
	ld hl, Route19TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route19Text2:
	asmtext
	ld hl, Route19TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route19Text3:
	asmtext
	ld hl, Route19TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route19Text4:
	asmtext
	ld hl, Route19TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route19Text5:
	asmtext
	ld hl, Route19TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route19Text6:
	asmtext
	ld hl, Route19TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route19Text7:
	asmtext
	ld hl, Route19TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

Route19Text8:
	asmtext
	ld hl, Route19TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

Route19Text9:
	asmtext
	ld hl, Route19TrainerHeader8
	call TalkToTrainer
	jp TextScriptEnd

Route19Text10:
	asmtext
	ld hl, Route19TrainerHeader9
	call TalkToTrainer
	jp TextScriptEnd

Route19BattleText1:
	fartext _Route19BattleText1
	done

Route19EndBattleText1:
	fartext _Route19EndBattleText1
	done

Route19AfterBattleText1:
	fartext _Route19AfterBattleText1
	done

Route19BattleText2:
	fartext _Route19BattleText2
	done

Route19EndBattleText2:
	fartext _Route19EndBattleText2
	done

Route19AfterBattleText2:
	fartext _Route19AfterBattleText2
	done

Route19BattleText3:
	fartext _Route19BattleText3
	done

Route19EndBattleText3:
	fartext _Route19EndBattleText3
	done

Route19AfterBattleText3:
	fartext _Route19AfterBattleText3
	done

Route19BattleText4:
	fartext _Route19BattleText4
	done

Route19EndBattleText4:
	fartext _Route19EndBattleText4
	done

Route19AfterBattleText4:
	fartext _Route19AfterBattleText4
	done

Route19BattleText5:
	fartext _Route19BattleText5
	done

Route19EndBattleText5:
	fartext _Route19EndBattleText5
	done

Route19AfterBattleText5:
	fartext _Route19AfterBattleText5
	done

Route19BattleText6:
	fartext _Route19BattleText6
	done

Route19EndBattleText6:
	fartext _Route19EndBattleText6
	done

Route19AfterBattleText6:
	fartext _Route19AfterBattleText6
	done

Route19BattleText7:
	fartext _Route19BattleText7
	done

Route19EndBattleText7:
	fartext _Route19EndBattleText7
	done

Route19AfterBattleText7:
	fartext _Route19AfterBattleText7
	done

Route19BattleText8:
	fartext _Route19BattleText8
	done

Route19EndBattleText8:
	fartext _Route19EndBattleText8
	done

Route19AfterBattleText8:
	fartext _Route19AfterBattleText8
	done

Route19BattleText9:
	fartext _Route19BattleText9
	done

Route19EndBattleText9:
	fartext _Route19EndBattleText9
	done

Route19AfterBattleText9:
	fartext _Route19AfterBattleText9
	done

Route19BattleText10:
	fartext _Route19BattleText10
	done

Route19EndBattleText10:
	fartext _Route19EndBattleText10
	done

Route19AfterBattleText10:
	fartext _Route19AfterBattleText10
	done

Route19Text11:
	fartext _Route19Text11
	done
