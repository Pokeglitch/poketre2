Route18Script:
	call EnableAutoTextBoxDrawing
	ld de, Route18ScriptPointers
	ld a, [wRoute18CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute18CurScript], a
	ret

Route18ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route18TextPointers:
	dw Route18Text1
	dw Route18Text2
	dw Route18Text3
	dw Route18Text4
	dw Route18Text5

Route18TrainerHeader0:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route18BattleText1 ; TextBeforeBattle
	dw Route18AfterBattleText1 ; TextAfterBattle
	dw Route18EndBattleText1 ; TextEndBattle
	dw Route18EndBattleText1 ; TextEndBattle

Route18TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route18BattleText2 ; TextBeforeBattle
	dw Route18AfterBattleText2 ; TextAfterBattle
	dw Route18EndBattleText2 ; TextEndBattle
	dw Route18EndBattleText2 ; TextEndBattle

Route18TrainerHeader2:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route18BattleText3 ; TextBeforeBattle
	dw Route18AfterBattleText3 ; TextAfterBattle
	dw Route18EndBattleText3 ; TextEndBattle
	dw Route18EndBattleText3 ; TextEndBattle

	db $ff

Route18Text1:
	asmtext
	ld hl, Route18TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route18BattleText1:
	fartext _Route18BattleText1
	done

Route18EndBattleText1:
	fartext _Route18EndBattleText1
	done

Route18AfterBattleText1:
	fartext _Route18AfterBattleText1
	done

Route18Text2:
	asmtext
	ld hl, Route18TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route18BattleText2:
	fartext _Route18BattleText2
	done

Route18EndBattleText2:
	fartext _Route18EndBattleText2
	done

Route18AfterBattleText2:
	fartext _Route18AfterBattleText2
	done

Route18Text3:
	asmtext
	ld hl, Route18TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route18BattleText3:
	fartext _Route18BattleText3
	done

Route18EndBattleText3:
	fartext _Route18EndBattleText3
	done

Route18AfterBattleText3:
	fartext _Route18AfterBattleText3
	done

Route18Text4:
	fartext _Route18Text4
	done

Route18Text5:
	fartext _Route18Text5
	done
