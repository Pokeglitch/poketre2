Route8Script:
	call EnableAutoTextBoxDrawing
	ld de, Route8ScriptPointers
	ld a, [wRoute8CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute8CurScript], a
	ret

Route8ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route8TextPointers:
	dw Route8Text1
	dw Route8Text2
	dw Route8Text3
	dw Route8Text4
	dw Route8Text5
	dw Route8Text6
	dw Route8Text7
	dw Route8Text8
	dw Route8Text9
	dw Route8Text10

Route8TrainerHeader0:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route8BattleText1 ; TextBeforeBattle
	dw Route8AfterBattleText1 ; TextAfterBattle
	dw Route8EndBattleText1 ; TextEndBattle
	dw Route8EndBattleText1 ; TextEndBattle

Route8TrainerHeader1:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route8BattleText2 ; TextBeforeBattle
	dw Route8AfterBattleText2 ; TextAfterBattle
	dw Route8EndBattleText2 ; TextEndBattle
	dw Route8EndBattleText2 ; TextEndBattle

Route8TrainerHeader2:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route8BattleText3 ; TextBeforeBattle
	dw Route8AfterBattleText3 ; TextAfterBattle
	dw Route8EndBattleText3 ; TextEndBattle
	dw Route8EndBattleText3 ; TextEndBattle

Route8TrainerHeader3:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route8BattleText4 ; TextBeforeBattle
	dw Route8AfterBattleText4 ; TextAfterBattle
	dw Route8EndBattleText4 ; TextEndBattle
	dw Route8EndBattleText4 ; TextEndBattle

Route8TrainerHeader4:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route8BattleText5 ; TextBeforeBattle
	dw Route8AfterBattleText5 ; TextAfterBattle
	dw Route8EndBattleText5 ; TextEndBattle
	dw Route8EndBattleText5 ; TextEndBattle

Route8TrainerHeader5:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route8BattleText6 ; TextBeforeBattle
	dw Route8AfterBattleText6 ; TextAfterBattle
	dw Route8EndBattleText6 ; TextEndBattle
	dw Route8EndBattleText6 ; TextEndBattle

Route8TrainerHeader6:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route8BattleText7 ; TextBeforeBattle
	dw Route8AfterBattleText7 ; TextAfterBattle
	dw Route8EndBattleText7 ; TextEndBattle
	dw Route8EndBattleText7 ; TextEndBattle

Route8TrainerHeader7:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route8BattleText8 ; TextBeforeBattle
	dw Route8AfterBattleText8 ; TextAfterBattle
	dw Route8EndBattleText8 ; TextEndBattle
	dw Route8EndBattleText8 ; TextEndBattle

Route8TrainerHeader8:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route8BattleText9 ; TextBeforeBattle
	dw Route8AfterBattleText9 ; TextAfterBattle
	dw Route8EndBattleText9 ; TextEndBattle
	dw Route8EndBattleText9 ; TextEndBattle

	db $ff

Route8Text1:
	asmtext
	ld hl, Route8TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route8BattleText1:
	fartext _Route8BattleText1
	done

Route8EndBattleText1:
	fartext _Route8EndBattleText1
	done

Route8AfterBattleText1:
	fartext _Route8AfterBattleText1
	done

Route8Text2:
	asmtext
	ld hl, Route8TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route8BattleText2:
	fartext _Route8BattleText2
	done

Route8EndBattleText2:
	fartext _Route8EndBattleText2
	done

Route8AfterBattleText2:
	fartext _Route8AfterBattleText2
	done

Route8Text3:
	asmtext
	ld hl, Route8TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route8BattleText3:
	fartext _Route8BattleText3
	done

Route8EndBattleText3:
	fartext _Route8EndBattleText3
	done

Route8AfterBattleText3:
	fartext _Route8AfterBattleText3
	done

Route8Text4:
	asmtext
	ld hl, Route8TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route8BattleText4:
	fartext _Route8BattleText4
	done

Route8EndBattleText4:
	fartext _Route8EndBattleText4
	done

Route8AfterBattleText4:
	fartext _Route8AfterBattleText4
	done

Route8Text5:
	asmtext
	ld hl, Route8TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route8BattleText5:
	fartext _Route8BattleText5
	done

Route8EndBattleText5:
	fartext _Route8EndBattleText5
	done

Route8AfterBattleText5:
	fartext _Route8AfterBattleText5
	done

Route8Text6:
	asmtext
	ld hl, Route8TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route8BattleText6:
	fartext _Route8BattleText6
	done

Route8EndBattleText6:
	fartext _Route8EndBattleText6
	done

Route8AfterBattleText6:
	fartext _Route8AfterBattleText6
	done

Route8Text7:
	asmtext
	ld hl, Route8TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

Route8BattleText7:
	fartext _Route8BattleText7
	done

Route8EndBattleText7:
	fartext _Route8EndBattleText7
	done

Route8AfterBattleText7:
	fartext _Route8AfterBattleText7
	done

Route8Text8:
	asmtext
	ld hl, Route8TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

Route8BattleText8:
	fartext _Route8BattleText8
	done

Route8EndBattleText8:
	fartext _Route8EndBattleText8
	done

Route8AfterBattleText8:
	fartext _Route8AfterBattleText8
	done

Route8Text9:
	asmtext
	ld hl, Route8TrainerHeader8
	call TalkToTrainer
	jp TextScriptEnd

Route8BattleText9:
	fartext _Route8BattleText9
	done

Route8EndBattleText9:
	fartext _Route8EndBattleText9
	done

Route8AfterBattleText9:
	fartext _Route8AfterBattleText9
	done

Route8Text10:
	fartext _Route8Text10
	done
