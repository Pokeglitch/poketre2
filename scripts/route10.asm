Route10Script:
	call EnableAutoTextBoxDrawing
	ld de, Route10ScriptPointers
	ld a, [wRoute10CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute10CurScript], a
	ret

Route10ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route10TextPointers:
	dw Route10Text1
	dw Route10Text2
	dw Route10Text3
	dw Route10Text4
	dw Route10Text5
	dw Route10Text6
	dw Route10Text7
	dw PokeCenterSignText
	dw Route10Text9
	dw Route10Text10

Route10TrainerHeader0:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route10BattleText1 ; TextBeforeBattle
	dw Route10AfterBattleText1 ; TextAfterBattle
	dw Route10EndBattleText1 ; TextEndBattle
	dw Route10EndBattleText1 ; TextEndBattle

Route10TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route10BattleText2 ; TextBeforeBattle
	dw Route10AfterBattleText2 ; TextAfterBattle
	dw Route10EndBattleText2 ; TextEndBattle
	dw Route10EndBattleText2 ; TextEndBattle

Route10TrainerHeader2:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route10BattleText3 ; TextBeforeBattle
	dw Route10AfterBattleText3 ; TextAfterBattle
	dw Route10EndBattleText3 ; TextEndBattle
	dw Route10EndBattleText3 ; TextEndBattle

Route10TrainerHeader3:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route10BattleText4 ; TextBeforeBattle
	dw Route10AfterBattleText4 ; TextAfterBattle
	dw Route10EndBattleText4 ; TextEndBattle
	dw Route10EndBattleText4 ; TextEndBattle

Route10TrainerHeader4:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route10BattleText5 ; TextBeforeBattle
	dw Route10AfterBattleText5 ; TextAfterBattle
	dw Route10EndBattleText5 ; TextEndBattle
	dw Route10EndBattleText5 ; TextEndBattle

Route10TrainerHeader5:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route10BattleText6 ; TextBeforeBattle
	dw Route10AfterBattleText6 ; TextAfterBattle
	dw Route10EndBattleText6 ; TextEndBattle
	dw Route10EndBattleText6 ; TextEndBattle

	db $ff

Route10Text1:
	asmtext
	ld hl, Route10TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route10BattleText1:
	fartext _Route10BattleText1
	done

Route10EndBattleText1:
	fartext _Route10EndBattleText1
	done

Route10AfterBattleText1:
	fartext _Route10AfterBattleText1
	done

Route10Text2:
	asmtext
	ld hl, Route10TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route10BattleText2:
	fartext _Route10BattleText2
	done

Route10EndBattleText2:
	fartext _Route10EndBattleText2
	done

Route10AfterBattleText2:
	fartext _Route10AfterBattleText2
	done

Route10Text3:
	asmtext
	ld hl, Route10TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route10BattleText3:
	fartext _Route10BattleText3
	done

Route10EndBattleText3:
	fartext _Route10EndBattleText3
	done

Route10AfterBattleText3:
	fartext _Route10AfterBattleText3
	done

Route10Text4:
	asmtext
	ld hl, Route10TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route10BattleText4:
	fartext _Route10BattleText4
	done

Route10EndBattleText4:
	fartext _Route10EndBattleText4
	done

Route10AfterBattleText4:
	fartext _Route10AfterBattleText4
	done

Route10Text5:
	asmtext
	ld hl, Route10TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route10BattleText5:
	fartext _Route10BattleText5
	done

Route10EndBattleText5:
	fartext _Route10EndBattleText5
	done

Route10AfterBattleText5:
	fartext _Route10AfterBattleText5
	done

Route10Text6:
	asmtext
	ld hl, Route10TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route10BattleText6:
	fartext _Route10BattleText6
	done

Route10EndBattleText6:
	fartext _Route10EndBattleText6
	done

Route10AfterBattleText6:
	fartext _Route10AfterBattleText6
	done

Route10Text9:
Route10Text7:
	fartext _Route10Text7 ; _Route10Text9
	done

Route10Text10:
	fartext _Route10Text10
	done
