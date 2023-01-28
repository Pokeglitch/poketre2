Route9Script:
	call EnableAutoTextBoxDrawing
	ld de, Route9ScriptPointers
	ld a, [wRoute9CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute9CurScript], a
	ret

Route9ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route9TextPointers:
	dw Route9Text1
	dw Route9Text2
	dw Route9Text3
	dw Route9Text4
	dw Route9Text5
	dw Route9Text6
	dw Route9Text7
	dw Route9Text8
	dw Route9Text9
	dw PickUpItemText
	dw Route9Text11

Route9TrainerHeader0:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route9BattleText1 ; TextBeforeBattle
	dw Route9AfterBattleText1 ; TextAfterBattle
	dw Route9EndBattleText1 ; TextEndBattle
	dw Route9EndBattleText1 ; TextEndBattle

Route9TrainerHeader1:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route9BattleText2 ; TextBeforeBattle
	dw Route9AfterBattleText2 ; TextAfterBattle
	dw Route9EndBattleText2 ; TextEndBattle
	dw Route9EndBattleText2 ; TextEndBattle

Route9TrainerHeader2:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route9BattleText3 ; TextBeforeBattle
	dw Route9AfterBattleText3 ; TextAfterBattle
	dw Route9EndBattleText3 ; TextEndBattle
	dw Route9EndBattleText3 ; TextEndBattle

Route9TrainerHeader3:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route9BattleText4 ; TextBeforeBattle
	dw Route9AfterBattleText4 ; TextAfterBattle
	dw Route9EndBattleText4 ; TextEndBattle
	dw Route9EndBattleText4 ; TextEndBattle

Route9TrainerHeader4:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route9BattleText5 ; TextBeforeBattle
	dw Route9AfterBattleText5 ; TextAfterBattle
	dw Route9EndBattleText5 ; TextEndBattle
	dw Route9EndBattleText5 ; TextEndBattle

Route9TrainerHeader5:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route9BattleText6 ; TextBeforeBattle
	dw Route9AfterBattleText6 ; TextAfterBattle
	dw Route9EndBattleText6 ; TextEndBattle
	dw Route9EndBattleText6 ; TextEndBattle

Route9TrainerHeader6:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route9BattleText7 ; TextBeforeBattle
	dw Route9AfterBattleText7 ; TextAfterBattle
	dw Route9EndBattleText7 ; TextEndBattle
	dw Route9EndBattleText7 ; TextEndBattle

Route9TrainerHeader7:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route9BattleText8 ; TextBeforeBattle
	dw Route9AfterBattleText8 ; TextAfterBattle
	dw Route9EndBattleText8 ; TextEndBattle
	dw Route9EndBattleText8 ; TextEndBattle

Route9TrainerHeader8:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route9BattleText9 ; TextBeforeBattle
	dw Route9AfterBattleText9 ; TextAfterBattle
	dw Route9EndBattleText9 ; TextEndBattle
	dw Route9EndBattleText9 ; TextEndBattle

	db $ff

Route9Text1:
	asmtext
	ld hl, Route9TrainerHeader0
	jr Route9TalkToTrainer

Route9Text2:
	asmtext
	ld hl, Route9TrainerHeader1
	jr Route9TalkToTrainer

Route9Text3:
	asmtext
	ld hl, Route9TrainerHeader2
	jr Route9TalkToTrainer

Route9Text4:
	asmtext
	ld hl, Route9TrainerHeader3
	jr Route9TalkToTrainer

Route9Text5:
	asmtext
	ld hl, Route9TrainerHeader4
	jr Route9TalkToTrainer

Route9Text6:
	asmtext
	ld hl, Route9TrainerHeader5
	jr Route9TalkToTrainer

Route9Text7:
	asmtext
	ld hl, Route9TrainerHeader6
	jr Route9TalkToTrainer

Route9Text8:
	asmtext
	ld hl, Route9TrainerHeader7
	jr Route9TalkToTrainer

Route9Text9:
	asmtext
	ld hl, Route9TrainerHeader8
Route9TalkToTrainer:
	call TalkToTrainer
	jp TextScriptEnd

Route9BattleText1:
	fartext _Route9BattleText1
	done

Route9EndBattleText1:
	fartext _Route9EndBattleText1
	done

Route9AfterBattleText1:
	fartext _Route9AfterBattleText1
	done

Route9BattleText2:
	fartext _Route9BattleText2
	done

Route9EndBattleText2:
	fartext _Route9EndBattleText2
	done

Route9AfterBattleText2:
	fartext _Route9AfterBattleText2
	done

Route9BattleText3:
	fartext _Route9BattleText3
	done

Route9EndBattleText3:
	fartext _Route9EndBattleText3
	done

Route9AfterBattleText3:
	fartext _Route9AfterBattleText3
	done

Route9BattleText4:
	fartext _Route9BattleText4
	done

Route9EndBattleText4:
	fartext _Route9EndBattleText4
	done

Route9AfterBattleText4:
	fartext _Route9AfterBattleText4
	done

Route9BattleText5:
	fartext _Route9BattleText5
	done

Route9EndBattleText5:
	fartext _Route9EndBattleText5
	done

Route9AfterBattleText5:
	fartext _Route9AfterBattleText5
	done

Route9BattleText6:
	fartext _Route9BattleText6
	done

Route9EndBattleText6:
	fartext _Route9EndBattleText6
	done

Route9AfterBattleText6:
	fartext _Route9AfterBattleText6
	done

Route9BattleText7:
	fartext _Route9BattleText7
	done

Route9EndBattleText7:
	fartext _Route9EndBattleText7
	done

Route9AfterBattleText7:
	fartext _Route9AfterBattleText7
	done

Route9BattleText8:
	fartext _Route9BattleText8
	done

Route9EndBattleText8:
	fartext _Route9EndBattleText8
	done

Route9AfterBattleText8:
	fartext _Route9AfterBattleText8
	done

Route9BattleText9:
	fartext _Route9BattleText9
	done

Route9EndBattleText9:
	fartext _Route9EndBattleText9
	done

Route9AfterBattleText9:
	fartext _Route9AfterBattleText9
	done

Route9Text11:
	fartext _Route9Text11
	done
