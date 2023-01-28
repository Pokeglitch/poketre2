Route20Script:
	CheckAndResetEvent EVENT_IN_SEAFOAM_ISLANDS
	call nz, Route20Script_50cc6
	call EnableAutoTextBoxDrawing
	ld de, Route20ScriptPointers
	ld a, [wRoute20CurScript]
	call ExecuteCurMapScriptInTable
	ld [wRoute20CurScript], a
	ret

Route20Script_50cc6:
	CheckBothEventsSet EVENT_SEAFOAM3_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM3_BOULDER2_DOWN_HOLE
	jr z, .asm_50cef
	ld a, HS_SEAFOAM_ISLANDS_1_BOULDER_1
	call Route20Script_50d0c
	ld a, HS_SEAFOAM_ISLANDS_1_BOULDER_2
	call Route20Script_50d0c
	ld hl, .MissableObjectIDs
.asm_50cdc
	ld a, [hli]
	cp $ff
	jr z, .asm_50cef
	push hl
	call Route20Script_50d14
	pop hl
	jr .asm_50cdc

.MissableObjectIDs:
	db HS_SEAFOAM_ISLANDS_2_BOULDER_1
	db HS_SEAFOAM_ISLANDS_2_BOULDER_2
	db HS_SEAFOAM_ISLANDS_3_BOULDER_1
	db HS_SEAFOAM_ISLANDS_3_BOULDER_2
	db HS_SEAFOAM_ISLANDS_4_BOULDER_3
	db HS_SEAFOAM_ISLANDS_4_BOULDER_4
	db $FF

.asm_50cef
	CheckBothEventsSet EVENT_SEAFOAM4_BOULDER1_DOWN_HOLE, EVENT_SEAFOAM4_BOULDER2_DOWN_HOLE
	ret z
	ld a, HS_SEAFOAM_ISLANDS_4_BOULDER_1
	call Route20Script_50d0c
	ld a, HS_SEAFOAM_ISLANDS_4_BOULDER_2
	call Route20Script_50d0c
	ld a, HS_SEAFOAM_ISLANDS_5_BOULDER_1
	call Route20Script_50d14
	ld a, HS_SEAFOAM_ISLANDS_5_BOULDER_2
	call Route20Script_50d14
	ret

Route20Script_50d0c:
	ld [wMissableObjectIndex], a
	predef_jump ShowObject

Route20Script_50d14:
	ld [wMissableObjectIndex], a
	predef_jump HideObject

Route20ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

Route20TextPointers:
	dw Route20Text1
	dw Route20Text2
	dw Route20Text3
	dw Route20Text4
	dw Route20Text5
	dw Route20Text6
	dw Route20Text7
	dw Route20Text8
	dw Route20Text9
	dw Route20Text10
	dw Route20Text11
	dw Route20Text12

Route20TrainerHeader0:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route20BattleText1 ; TextBeforeBattle
	dw Route20AfterBattleText1 ; TextAfterBattle
	dw Route20EndBattleText1 ; TextEndBattle
	dw Route20EndBattleText1 ; TextEndBattle

Route20TrainerHeader1:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route20BattleText2 ; TextBeforeBattle
	dw Route20AfterBattleText2 ; TextAfterBattle
	dw Route20EndBattleText2 ; TextEndBattle
	dw Route20EndBattleText2 ; TextEndBattle

Route20TrainerHeader2:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route20BattleText3 ; TextBeforeBattle
	dw Route20AfterBattleText3 ; TextAfterBattle
	dw Route20EndBattleText3 ; TextEndBattle
	dw Route20EndBattleText3 ; TextEndBattle

Route20TrainerHeader3:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route20BattleText4 ; TextBeforeBattle
	dw Route20AfterBattleText4 ; TextAfterBattle
	dw Route20EndBattleText4 ; TextEndBattle
	dw Route20EndBattleText4 ; TextEndBattle

Route20TrainerHeader4:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route20BattleText5 ; TextBeforeBattle
	dw Route20AfterBattleText5 ; TextAfterBattle
	dw Route20EndBattleText5 ; TextEndBattle
	dw Route20EndBattleText5 ; TextEndBattle

Route20TrainerHeader5:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route20BattleText6 ; TextBeforeBattle
	dw Route20AfterBattleText6 ; TextAfterBattle
	dw Route20EndBattleText6 ; TextEndBattle
	dw Route20EndBattleText6 ; TextEndBattle

Route20TrainerHeader6:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route20BattleText7 ; TextBeforeBattle
	dw Route20AfterBattleText7 ; TextAfterBattle
	dw Route20EndBattleText7 ; TextEndBattle
	dw Route20EndBattleText7 ; TextEndBattle

Route20TrainerHeader7:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route20BattleText8 ; TextBeforeBattle
	dw Route20AfterBattleText8 ; TextAfterBattle
	dw Route20EndBattleText8 ; TextEndBattle
	dw Route20EndBattleText8 ; TextEndBattle

Route20TrainerHeader8:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route20BattleText9 ; TextBeforeBattle
	dw Route20AfterBattleText9 ; TextAfterBattle
	dw Route20EndBattleText9 ; TextEndBattle
	dw Route20EndBattleText9 ; TextEndBattle

Route20TrainerHeader9:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw Route20BattleText10 ; TextBeforeBattle
	dw Route20AfterBattleText10 ; TextAfterBattle
	dw Route20EndBattleText10 ; TextEndBattle
	dw Route20EndBattleText10 ; TextEndBattle

	db $ff

Route20Text1:
	asmtext
	ld hl, Route20TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

Route20Text2:
	asmtext
	ld hl, Route20TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

Route20Text3:
	asmtext
	ld hl, Route20TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

Route20Text4:
	asmtext
	ld hl, Route20TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

Route20Text5:
	asmtext
	ld hl, Route20TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

Route20Text6:
	asmtext
	ld hl, Route20TrainerHeader5
	call TalkToTrainer
	jp TextScriptEnd

Route20Text7:
	asmtext
	ld hl, Route20TrainerHeader6
	call TalkToTrainer
	jp TextScriptEnd

Route20Text8:
	asmtext
	ld hl, Route20TrainerHeader7
	call TalkToTrainer
	jp TextScriptEnd

Route20Text9:
	asmtext
	ld hl, Route20TrainerHeader8
	call TalkToTrainer
	jp TextScriptEnd

Route20Text10:
	asmtext
	ld hl, Route20TrainerHeader9
	call TalkToTrainer
	jp TextScriptEnd

Route20BattleText1:
	fartext _Route20BattleText1
	done

Route20EndBattleText1:
	fartext _Route20EndBattleText1
	done

Route20AfterBattleText1:
	fartext _Route20AfterBattleText1
	done

Route20BattleText2:
	fartext _Route20BattleText2
	done

Route20EndBattleText2:
	fartext _Route20EndBattleText2
	done

Route20AfterBattleText2:
	fartext _Route20AfterBattleText2
	done

Route20BattleText3:
	fartext _Route20BattleText3
	done

Route20EndBattleText3:
	fartext _Route20EndBattleText3
	done

Route20AfterBattleText3:
	fartext _Route20AfterBattleText3
	done

Route20BattleText4:
	fartext _Route20BattleText4
	done

Route20EndBattleText4:
	fartext _Route20EndBattleText4
	done

Route20AfterBattleText4:
	fartext _Route20AfterBattleText4
	done

Route20BattleText5:
	fartext _Route20BattleText5
	done

Route20EndBattleText5:
	fartext _Route20EndBattleText5
	done

Route20AfterBattleText5:
	fartext _Route20AfterBattleText5
	done

Route20BattleText6:
	fartext _Route20BattleText6
	done

Route20EndBattleText6:
	fartext _Route20EndBattleText6
	done

Route20AfterBattleText6:
	fartext _Route20AfterBattleText6
	done

Route20BattleText7:
	fartext _Route20BattleText7
	done

Route20EndBattleText7:
	fartext _Route20EndBattleText7
	done

Route20AfterBattleText7:
	fartext _Route20AfterBattleText7
	done

Route20BattleText8:
	fartext _Route20BattleText8
	done

Route20EndBattleText8:
	fartext _Route20EndBattleText8
	done

Route20AfterBattleText8:
	fartext _Route20AfterBattleText8
	done

Route20BattleText9:
	fartext _Route20BattleText9
	done

Route20EndBattleText9:
	fartext _Route20EndBattleText9
	done

Route20AfterBattleText9:
	fartext _Route20AfterBattleText9
	done

Route20BattleText10:
	fartext _Route20BattleText10
	done

Route20EndBattleText10:
	fartext _Route20EndBattleText10
	done

Route20AfterBattleText10:
	fartext _Route20AfterBattleText10
	done

Route20Text12:
Route20Text11:
	fartext _Route20Text11
	done
