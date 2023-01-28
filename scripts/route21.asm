Route21Script:
	call EnableAutoTextBoxDrawing
	ld de, Route21ScriptPointers
	ld a, [wRoute21CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute21CurScript], a
	ret

Route21ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route21TextPointers:
	dw Route21Text1
	dw Route21Text2
	dw Route21Text3
	dw Route21Text4
	dw Route21Text5
	dw Route21Text6
	dw Route21Text7
	dw Route21Text8
	dw Route21Text9

Route21TrainerHeader0:
	db 0 ; former event flag bit index
	db ($0 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route21BattleText1 ; TextBeforeBattle
	dw Route21AfterBattleText1 ; TextAfterBattle
	dw Route21EndBattleText1 ; TextEndBattle
	dw Route21EndBattleText1 ; TextEndBattle

Route21TrainerHeader1:
	db 0 ; former event flag bit index
	db ($0 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route21BattleText2 ; TextBeforeBattle
	dw Route21AfterBattleText2 ; TextAfterBattle
	dw Route21EndBattleText2 ; TextEndBattle
	dw Route21EndBattleText2 ; TextEndBattle

Route21TrainerHeader2:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route21BattleText3 ; TextBeforeBattle
	dw Route21AfterBattleText3 ; TextAfterBattle
	dw Route21EndBattleText3 ; TextEndBattle
	dw Route21EndBattleText3 ; TextEndBattle

Route21TrainerHeader3:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route21BattleText4 ; TextBeforeBattle
	dw Route21AfterBattleText4 ; TextAfterBattle
	dw Route21EndBattleText4 ; TextEndBattle
	dw Route21EndBattleText4 ; TextEndBattle

Route21TrainerHeader4:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route21BattleText5 ; TextBeforeBattle
	dw Route21AfterBattleText5 ; TextAfterBattle
	dw Route21EndBattleText5 ; TextEndBattle
	dw Route21EndBattleText5 ; TextEndBattle

Route21TrainerHeader5:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route21BattleText6 ; TextBeforeBattle
	dw Route21AfterBattleText6 ; TextAfterBattle
	dw Route21EndBattleText6 ; TextEndBattle
	dw Route21EndBattleText6 ; TextEndBattle

Route21TrainerHeader6:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route21BattleText7 ; TextBeforeBattle
	dw Route21AfterBattleText7 ; TextAfterBattle
	dw Route21EndBattleText7 ; TextEndBattle
	dw Route21EndBattleText7 ; TextEndBattle

Route21TrainerHeader7:
	db 0 ; former event flag bit index
	db ($0 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route21BattleText8 ; TextBeforeBattle
	dw Route21AfterBattleText8 ; TextAfterBattle
	dw Route21EndBattleText8 ; TextEndBattle
	dw Route21EndBattleText8 ; TextEndBattle

Route21TrainerHeader8:
	db 0 ; former event flag bit index
	db ($0 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route21BattleText9 ; TextBeforeBattle
	dw Route21AfterBattleText9 ; TextAfterBattle
	dw Route21EndBattleText9 ; TextEndBattle
	dw Route21EndBattleText9 ; TextEndBattle

	db $ff

Route21Text1:
	asmtext
	ld hl, Route21TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route21Text2:
	asmtext
	ld hl, Route21TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route21Text3:
	asmtext
	ld hl, Route21TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route21Text4:
	asmtext
	ld hl, Route21TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route21Text5:
	asmtext
	ld hl, Route21TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route21Text6:
	asmtext
	ld hl, Route21TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route21Text7:
	asmtext
	ld hl, Route21TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

Route21Text8:
	asmtext
	ld hl, Route21TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

Route21Text9:
	asmtext
	ld hl, Route21TrainerHeader8
	call TalkToTrainer
	jp TextScriptEnd

Route21BattleText1:
	fartext _Route21BattleText1
	done

Route21EndBattleText1:
	fartext _Route21EndBattleText1
	done

Route21AfterBattleText1:
	fartext _Route21AfterBattleText1
	done

Route21BattleText2:
	fartext _Route21BattleText2
	done

Route21EndBattleText2:
	fartext _Route21EndBattleText2
	done

Route21AfterBattleText2:
	fartext _Route21AfterBattleText2
	done

Route21BattleText3:
	fartext _Route21BattleText3
	done

Route21EndBattleText3:
	fartext _Route21EndBattleText3
	done

Route21AfterBattleText3:
	fartext _Route21AfterBattleText3
	done

Route21BattleText4:
	fartext _Route21BattleText4
	done

Route21EndBattleText4:
	fartext _Route21EndBattleText4
	done

Route21AfterBattleText4:
	fartext _Route21AfterBattleText4
	done

Route21BattleText5:
	fartext _Route21BattleText5
	done

Route21EndBattleText5:
	fartext _Route21EndBattleText5
	done

Route21AfterBattleText5:
	fartext _Route21AfterBattleText5
	done

Route21BattleText6:
	fartext _Route21BattleText6
	done

Route21EndBattleText6:
	fartext _Route21EndBattleText6
	done

Route21AfterBattleText6:
	fartext _Route21AfterBattleText6
	done

Route21BattleText7:
	fartext _Route21BattleText7
	done

Route21EndBattleText7:
	fartext _Route21EndBattleText7
	done

Route21AfterBattleText7:
	fartext _Route21AfterBattleText7
	done

Route21BattleText8:
	fartext _Route21BattleText8
	done

Route21EndBattleText8:
	fartext _Route21EndBattleText8
	done

Route21AfterBattleText8:
	fartext _Route21AfterBattleText8
	done

Route21BattleText9:
	fartext _Route21BattleText9
	done

Route21EndBattleText9:
	fartext _Route21EndBattleText9
	done

Route21AfterBattleText9:
	fartext _Route21AfterBattleText9
	done
