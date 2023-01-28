VictoryRoad2Script:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, VictoryRoad2Script_517c4
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	call nz, VictoryRoad2Script_517c9
	call EnableAutoTextBoxDrawing
	ld hl, VictoryRoad2TrainerHeader0
	ld de, VictoryRoad2ScriptPointers
	ld a, [wVictoryRoad2CurScript]
	call ExecuteCurMapScriptInTable
	ld [wVictoryRoad2CurScript], a
	ret

VictoryRoad2Script_517c4:
	ResetEvent EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH

VictoryRoad2Script_517c9:
	CheckEvent EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH1
	jr z, .asm_517da
	push af
	ld a, $15
	lb bc, 4, 3
	call VictoryRoad2Script_517e2
	pop af
.asm_517da
	bit 7, a
	ret z
	ld a, $1d
	lb bc, 7, 11

VictoryRoad2Script_517e2:
	ld [wNewTileBlockID], a
	predef ReplaceTileBlock
	ret

VictoryRoad2ScriptPointers:
	dw VictoryRoad2Script0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

VictoryRoad2Script0:
	ld hl, CoordsData_51816
	call CheckBoulderCoords
	jp nc, CheckFightingMapTrainers
	EventFlagAddress hl, EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH1
	ld a, [wCoordIndex]
	cp $2
	jr z, .asm_5180b
	CheckEventReuseHL EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH1
	SetEventReuseHL EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH1
	ret nz
	jr .asm_51810
.asm_5180b
	CheckEventAfterBranchReuseHL EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH2, EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH1
	SetEventReuseHL EVENT_VICTORY_ROAD_2_BOULDER_ON_SWITCH2
	ret nz
.asm_51810
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	ret

CoordsData_51816:
	db $10,$01
	db $10,$09
	db $FF

VictoryRoad2TextPointers:
	dw VictoryRoad2Text1
	dw VictoryRoad2Text2
	dw VictoryRoad2Text3
	dw VictoryRoad2Text4
	dw VictoryRoad2Text5
	dw MoltresText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw PickUpItemText
	dw BoulderText
	dw BoulderText
	dw BoulderText

VictoryRoad2TrainerHeader0:
	db 0 ; former event flag bit index
	db ($4 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw VictoryRoad2BattleText1 ; TextBeforeBattle
	dw VictoryRoad2AfterBattleText1 ; TextAfterBattle
	dw VictoryRoad2EndBattleText1 ; TextEndBattle
	dw VictoryRoad2EndBattleText1 ; TextEndBattle

VictoryRoad2TrainerHeader1:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw VictoryRoad2BattleText2 ; TextBeforeBattle
	dw VictoryRoad2AfterBattleText2 ; TextAfterBattle
	dw VictoryRoad2EndBattleText2 ; TextEndBattle
	dw VictoryRoad2EndBattleText2 ; TextEndBattle

VictoryRoad2TrainerHeader2:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw VictoryRoad2BattleText3 ; TextBeforeBattle
	dw VictoryRoad2AfterBattleText3 ; TextAfterBattle
	dw VictoryRoad2EndBattleText3 ; TextEndBattle
	dw VictoryRoad2EndBattleText3 ; TextEndBattle

VictoryRoad2TrainerHeader3:
	db 0 ; former event flag bit index
	db ($1 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw VictoryRoad2BattleText4 ; TextBeforeBattle
	dw VictoryRoad2AfterBattleText4 ; TextAfterBattle
	dw VictoryRoad2EndBattleText4 ; TextEndBattle
	dw VictoryRoad2EndBattleText4 ; TextEndBattle

VictoryRoad2TrainerHeader4:
	db 0 ; former event flag bit index
	db ($3 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw VictoryRoad2BattleText5 ; TextBeforeBattle
	dw VictoryRoad2AfterBattleText5 ; TextAfterBattle
	dw VictoryRoad2EndBattleText5 ; TextEndBattle
	dw VictoryRoad2EndBattleText5 ; TextEndBattle

MoltresTrainerHeader:
	db 0 ; former event flag bit index
	db ($0 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw MoltresBattleText ; TextBeforeBattle
	dw MoltresBattleText ; TextAfterBattle
	dw MoltresBattleText ; TextEndBattle
	dw MoltresBattleText ; TextEndBattle

	db $ff

VictoryRoad2Text1:
	asmtext
	ld hl, VictoryRoad2TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad2Text2:
	asmtext
	ld hl, VictoryRoad2TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad2Text3:
	asmtext
	ld hl, VictoryRoad2TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad2Text4:
	asmtext
	ld hl, VictoryRoad2TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad2Text5:
	asmtext
	ld hl, VictoryRoad2TrainerHeader4
	call TalkToTrainer
	jp TextScriptEnd

MoltresText:
	asmtext
	ld hl, MoltresTrainerHeader
	call TalkToTrainer
	jp TextScriptEnd

MoltresBattleText:
	fartext _MoltresBattleText
	asmtext
	ld a, MOLTRES
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

VictoryRoad2BattleText1:
	fartext _VictoryRoad2BattleText1
	done

VictoryRoad2EndBattleText1:
	fartext _VictoryRoad2EndBattleText1
	done

VictoryRoad2AfterBattleText1:
	fartext _VictoryRoad2AfterBattleText1
	done

VictoryRoad2BattleText2:
	fartext _VictoryRoad2BattleText2
	done

VictoryRoad2EndBattleText2:
	fartext _VictoryRoad2EndBattleText2
	done

VictoryRoad2AfterBattleText2:
	fartext _VictoryRoad2AfterBattleText2
	done

VictoryRoad2BattleText3:
	fartext _VictoryRoad2BattleText3
	done

VictoryRoad2EndBattleText3:
	fartext _VictoryRoad2EndBattleText3
	done

VictoryRoad2AfterBattleText3:
	fartext _VictoryRoad2AfterBattleText3
	done

VictoryRoad2BattleText4:
	fartext _VictoryRoad2BattleText4
	done

VictoryRoad2EndBattleText4:
	fartext _VictoryRoad2EndBattleText4
	done

VictoryRoad2AfterBattleText4:
	fartext _VictoryRoad2AfterBattleText4
	done

VictoryRoad2BattleText5:
	fartext _VictoryRoad2BattleText5
	done

VictoryRoad2EndBattleText5:
	fartext _VictoryRoad2EndBattleText5
	done

VictoryRoad2AfterBattleText5:
	fartext _VictoryRoad2AfterBattleText5
	done
