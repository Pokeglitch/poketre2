Route25Script:
	call Route25Script_515e1
	call EnableAutoTextBoxDrawing
	ld de, Route25ScriptPointers
	ld a, [wRoute25CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute25CurScript], a
	ret

Route25Script_515e1:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	ret z
	CheckEventHL EVENT_LEFT_BILLS_HOUSE_AFTER_HELPING
	ret nz
	CheckEventReuseHL EVENT_MET_BILL_2
	jr nz, .asm_515ff
	ResetEventReuseHL EVENT_BILL_SAID_USE_CELL_SEPARATOR
	ld a, HS_BILL_POKEMON
	ld [wMissableObjectIndex], a
	predef_jump ShowObject
.asm_515ff
	CheckEventAfterBranchReuseHL EVENT_GOT_SS_TICKET, EVENT_MET_BILL_2
	ret z
	SetEventReuseHL EVENT_LEFT_BILLS_HOUSE_AFTER_HELPING
	ld a, HS_NUGGET_BRIDGE_GUY
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_BILL_1
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_BILL_2
	ld [wMissableObjectIndex], a
	predef_jump ShowObject

Route25ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route25TextPointers:
	dw Route25Text1
	dw Route25Text2
	dw Route25Text3
	dw Route25Text4
	dw Route25Text5
	dw Route25Text6
	dw Route25Text7
	dw Route25Text8
	dw Route25Text9
	dw PickUpItemText
	dw Route25Text11

Route25TrainerHeader0:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route25BattleText1 ; TextBeforeBattle
	dw Route25AfterBattleText1 ; TextAfterBattle
	dw Route25EndBattleText1 ; TextEndBattle
	dw Route25EndBattleText1 ; TextEndBattle

Route25TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route25BattleText2 ; TextBeforeBattle
	dw Route25AfterBattleText2 ; TextAfterBattle
	dw Route25EndBattleText2 ; TextEndBattle
	dw Route25EndBattleText2 ; TextEndBattle

Route25TrainerHeader2:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route25BattleText3 ; TextBeforeBattle
	dw Route25AfterBattleText3 ; TextAfterBattle
	dw Route25EndBattleText3 ; TextEndBattle
	dw Route25EndBattleText3 ; TextEndBattle

Route25TrainerHeader3:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route25BattleText4 ; TextBeforeBattle
	dw Route25AfterBattleText4 ; TextAfterBattle
	dw Route25EndBattleText4 ; TextEndBattle
	dw Route25EndBattleText4 ; TextEndBattle

Route25TrainerHeader4:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route25BattleText5 ; TextBeforeBattle
	dw Route25AfterBattleText5 ; TextAfterBattle
	dw Route25EndBattleText5 ; TextEndBattle
	dw Route25EndBattleText5 ; TextEndBattle

Route25TrainerHeader5:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route25BattleText6 ; TextBeforeBattle
	dw Route25AfterBattleText6 ; TextAfterBattle
	dw Route25EndBattleText6 ; TextEndBattle
	dw Route25EndBattleText6 ; TextEndBattle

Route25TrainerHeader6:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route25BattleText7 ; TextBeforeBattle
	dw Route25AfterBattleText7 ; TextAfterBattle
	dw Route25EndBattleText7 ; TextEndBattle
	dw Route25EndBattleText7 ; TextEndBattle

Route25TrainerHeader7:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route25BattleText8 ; TextBeforeBattle
	dw Route25AfterBattleText8 ; TextAfterBattle
	dw Route25EndBattleText8 ; TextEndBattle
	dw Route25EndBattleText8 ; TextEndBattle

Route25TrainerHeader8:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route25BattleText9 ; TextBeforeBattle
	dw Route25AfterBattleText9 ; TextAfterBattle
	dw Route25EndBattleText9 ; TextEndBattle
	dw Route25EndBattleText9 ; TextEndBattle

	db $ff

Route25Text1:
	asmtext
	ld hl, Route25TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route25Text2:
	asmtext
	ld hl, Route25TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route25Text3:
	asmtext
	ld hl, Route25TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route25Text4:
	asmtext
	ld hl, Route25TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route25Text5:
	asmtext
	ld hl, Route25TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route25Text6:
	asmtext
	ld hl, Route25TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route25Text7:
	asmtext
	ld hl, Route25TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

Route25Text8:
	asmtext
	ld hl, Route25TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

Route25Text9:
	asmtext
	ld hl, Route25TrainerHeader8
	call TalkToTrainer
	jp TextScriptEnd

Route25BattleText1:
	fartext _Route25BattleText1
	done

Route25EndBattleText1:
	fartext _Route25EndBattleText1
	done

Route25AfterBattleText1:
	fartext _Route25AfterBattleText1
	done

Route25BattleText2:
	fartext _Route25BattleText2
	done

Route25EndBattleText2:
	fartext _Route25EndBattleText2
	done

Route25AfterBattleText2:
	fartext _Route25AfterBattleText2
	done

Route25BattleText3:
	fartext _Route25BattleText3
	done

Route25EndBattleText3:
	fartext _Route25EndBattleText3
	done

Route25AfterBattleText3:
	fartext _Route25AfterBattleText3
	done

Route25BattleText4:
	fartext _Route25BattleText4
	done

Route25EndBattleText4:
	fartext _Route25EndBattleText4
	done

Route25AfterBattleText4:
	fartext _Route25AfterBattleText4
	done

Route25BattleText5:
	fartext _Route25BattleText5
	done

Route25EndBattleText5:
	fartext _Route25EndBattleText5
	done

Route25AfterBattleText5:
	fartext _Route25AfterBattleText5
	done

Route25BattleText6:
	fartext _Route25BattleText6
	done

Route25EndBattleText6:
	fartext _Route25EndBattleText6
	done

Route25AfterBattleText6:
	fartext _Route25AfterBattleText6
	done

Route25BattleText7:
	fartext _Route25BattleText7
	done

Route25EndBattleText7:
	fartext _Route25EndBattleText7
	done

Route25AfterBattleText7:
	fartext _Route25AfterBattleText7
	done

Route25BattleText8:
	fartext _Route25BattleText8
	done

Route25EndBattleText8:
	fartext _Route25EndBattleText8
	done

Route25AfterBattleText8:
	fartext _Route25AfterBattleText8
	done

Route25BattleText9:
	fartext _Route25BattleText9
	done

Route25EndBattleText9:
	fartext _Route25EndBattleText9
	done

Route25AfterBattleText9:
	fartext _Route25AfterBattleText9
	done

Route25Text11:
	fartext _Route25Text11
	done
