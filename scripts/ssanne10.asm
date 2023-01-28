SSAnne10Script:
	call EnableAutoTextBoxDrawing
	ld de, SSAnne10ScriptPointers
	ld a, [wSSAnne10CurScript]
	call ExecuteCurMapScriptInTable
	ld [wSSAnne10CurScript], a
	ret

SSAnne10ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

SSAnne10TextPointers:
	dw SSAnne10Text1
	dw SSAnne10Text2
	dw SSAnne10Text3
	dw SSAnne10Text4
	dw SSAnne10Text5
	dw SSAnne10Text6
	dw SSAnne10Text7
	dw SSAnne10Text8
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText

SSAnne10TrainerHeader0:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SSAnne10BattleText1 ; TextBeforeBattle
	dw SSAnne10AfterBattleText1 ; TextAfterBattle
	dw SSAnne10EndBattleText1 ; TextEndBattle
	dw SSAnne10EndBattleText1 ; TextEndBattle

SSAnne10TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SSAnne10BattleText2 ; TextBeforeBattle
	dw SSAnne10AfterBattleText2 ; TextAfterBattle
	dw SSAnne10EndBattleText2 ; TextEndBattle
	dw SSAnne10EndBattleText2 ; TextEndBattle

SSAnne10TrainerHeader2:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SSAnne10BattleText3 ; TextBeforeBattle
	dw SSAnne10AfterBattleText3 ; TextAfterBattle
	dw SSAnne10EndBattleText3 ; TextEndBattle
	dw SSAnne10EndBattleText3 ; TextEndBattle

SSAnne10TrainerHeader3:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SSAnne10BattleText4 ; TextBeforeBattle
	dw SSAnne10AfterBattleText4 ; TextAfterBattle
	dw SSAnne10EndBattleText4 ; TextEndBattle
	dw SSAnne10EndBattleText4 ; TextEndBattle

SSAnne10TrainerHeader4:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SSAnne10BattleText5 ; TextBeforeBattle
	dw SSAnne10AfterBattleText5 ; TextAfterBattle
	dw SSAnne10EndBattleText5 ; TextEndBattle
	dw SSAnne10EndBattleText5 ; TextEndBattle

SSAnne10TrainerHeader5:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw SSAnne10BattleText6 ; TextBeforeBattle
	dw SSAnne10AfterBattleText6 ; TextAfterBattle
	dw SSAnne10EndBattleText6 ; TextEndBattle
	dw SSAnne10EndBattleText6 ; TextEndBattle

	db $ff

SSAnne10Text1:
	asmtext
	ld hl, SSAnne10TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

SSAnne10Text2:
	asmtext
	ld hl, SSAnne10TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

SSAnne10Text3:
	asmtext
	ld hl, SSAnne10TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

SSAnne10Text4:
	asmtext
	ld hl, SSAnne10TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

SSAnne10Text5:
	asmtext
	ld hl, SSAnne10TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

SSAnne10Text6:
	asmtext
	ld hl, SSAnne10TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

SSAnne10Text8:
	fartext _SSAnne10Text8
	asmtext
	ld a, MACHOKE
	call PlayCry
	jp TextScriptEnd

SSAnne10BattleText1:
	fartext _SSAnne10BattleText1
	done

SSAnne10EndBattleText1:
	fartext _SSAnne10EndBattleText1
	done

SSAnne10AfterBattleText1:
	fartext _SSAnne10AfterBattleText1
	done

SSAnne10BattleText2:
	fartext _SSAnne10BattleText2
	done

SSAnne10EndBattleText2:
	fartext _SSAnne10EndBattleText2
	done

SSAnne10AfterBattleText2:
	fartext _SSAnne10AfterBattleText2
	done

SSAnne10BattleText3:
	fartext _SSAnne10BattleText3
	done

SSAnne10EndBattleText3:
	fartext _SSAnne10EndBattleText3
	done

SSAnne10AfterBattleText3:
	fartext _SSAnne10AfterBattleText3
	done

SSAnne10BattleText4:
	fartext _SSAnne10BattleText4
	done

SSAnne10EndBattleText4:
	fartext _SSAnne10EndBattleText4
	done

SSAnne10AfterBattleText4:
	fartext _SSAnne10AfterBattleText4
	done

SSAnne10BattleText5:
	fartext _SSAnne10BattleText5
	done

SSAnne10EndBattleText5:
	fartext _SSAnne10EndBattleText5
	done

SSAnne10AfterBattleText5:
	fartext _SSAnne10AfterBattleText5
	done

SSAnne10BattleText6:
	fartext _SSAnne10BattleText6
	done

SSAnne10EndBattleText6:
	fartext _SSAnne10EndBattleText6
	done

SSAnne10AfterBattleText6:
	fartext _SSAnne10AfterBattleText6
	done

SSAnne10Text7:
	fartext _SSAnne10Text7
	done
