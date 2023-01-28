MtMoon1Script:
	call EnableAutoTextBoxDrawing
	ld hl, MtMoon1TrainerHeader0
	ld de, MtMoon1ScriptPointers
	ld a, [wMtMoon1CurScript]
	call ExecuteCurMapScriptInTable
	ld [wMtMoon1CurScript], a
	ret

MtMoon1ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

MtMoon1TextPointers:
	dw MtMoon1Text1
	dw MtMoon1Text2
	dw MtMoon1Text3
	dw MtMoon1Text4
	dw MtMoon1Text5
	dw MtMoon1Text6
	dw MtMoon1Text7
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw MtMoon1Text14

MtMoon1TrainerHeader0:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw MtMoon1BattleText2 ; TextBeforeBattle
	dw MtMoon1AfterBattleText2 ; TextAfterBattle
	dw MtMoon1EndBattleText2 ; TextEndBattle
	dw MtMoon1EndBattleText2 ; TextEndBattle

MtMoon1TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw MtMoon1BattleText3 ; TextBeforeBattle
	dw MtMoon1AfterBattleText3 ; TextAfterBattle
	dw MtMoon1EndBattleText3 ; TextEndBattle
	dw MtMoon1EndBattleText3 ; TextEndBattle

MtMoon1TrainerHeader2:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw MtMoon1BattleText4 ; TextBeforeBattle
	dw MtMoon1AfterBattleText4 ; TextAfterBattle
	dw MtMoon1EndBattleText4 ; TextEndBattle
	dw MtMoon1EndBattleText4 ; TextEndBattle

MtMoon1TrainerHeader3:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw MtMoon1BattleText5 ; TextBeforeBattle
	dw MtMoon1AfterBattleText5 ; TextAfterBattle
	dw MtMoon1EndBattleText5 ; TextEndBattle
	dw MtMoon1EndBattleText5 ; TextEndBattle

MtMoon1TrainerHeader4:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw MtMoon1BattleText6 ; TextBeforeBattle
	dw MtMoon1AfterBattleText6 ; TextAfterBattle
	dw MtMoon1EndBattleText6 ; TextEndBattle
	dw MtMoon1EndBattleText6 ; TextEndBattle

MtMoon1TrainerHeader5:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw MtMoon1BattleText7 ; TextBeforeBattle
	dw MtMoon1AfterBattleText7 ; TextAfterBattle
	dw MtMoon1EndBattleText7 ; TextEndBattle
	dw MtMoon1EndBattleText7 ; TextEndBattle

MtMoon1TrainerHeader6:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw MtMoon1BattleText8 ; TextBeforeBattle
	dw MtMoon1AfterBattleText8 ; TextAfterBattle
	dw MtMoon1EndBattleText8 ; TextEndBattle
	dw MtMoon1EndBattleText8 ; TextEndBattle

	db $ff

MtMoon1Text1:
	asmtext
	ld hl, MtMoon1TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1Text2:
	asmtext
	ld hl, MtMoon1TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1Text3:
	asmtext
	ld hl, MtMoon1TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1Text4:
	asmtext
	ld hl, MtMoon1TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1Text5:
	asmtext
	ld hl, MtMoon1TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1Text6:
	asmtext
	ld hl, MtMoon1TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1Text7:
	asmtext
	ld hl, MtMoon1TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

MtMoon1BattleText2:
	fartext _MtMoon1BattleText2
	done

MtMoon1EndBattleText2:
	fartext _MtMoon1EndBattleText2
	done

MtMoon1AfterBattleText2:
	fartext _MtMoon1AfterBattleText2
	done

MtMoon1BattleText3:
	fartext _MtMoon1BattleText3
	done

MtMoon1EndBattleText3:
	fartext _MtMoon1EndBattleText3
	done

MtMoon1AfterBattleText3:
	fartext _MtMoon1AfterBattleText3
	done

MtMoon1BattleText4:
	fartext _MtMoon1BattleText4
	done

MtMoon1EndBattleText4:
	fartext _MtMoon1EndBattleText4
	done

MtMoon1AfterBattleText4:
	fartext _MtMoon1AfterBattleText4
	done

MtMoon1BattleText5:
	fartext _MtMoon1BattleText5
	done

MtMoon1EndBattleText5:
	fartext _MtMoon1EndBattleText5
	done

MtMoon1AfterBattleText5:
	fartext _MtMoon1AfterBattleText5
	done

MtMoon1BattleText6:
	fartext _MtMoon1BattleText6
	done

MtMoon1EndBattleText6:
	fartext _MtMoon1EndBattleText6
	done

MtMoon1AfterBattleText6:
	fartext _MtMoon1AfterBattleText6
	done

MtMoon1BattleText7:
	fartext _MtMoon1BattleText7
	done

MtMoon1EndBattleText7:
	fartext _MtMoon1EndBattleText7
	done

MtMoon1AfterBattleText7:
	fartext _MtMoon1AfterBattleText7
	done

MtMoon1BattleText8:
	fartext _MtMoon1BattleText8
	done

MtMoon1EndBattleText8:
	fartext _MtMoon1EndBattleText8
	done

MtMoon1AfterBattleText8:
	fartext _MtMoon1AfterBattleText8
	done

MtMoon1Text14:
	fartext _MtMoon1Text14
	done
