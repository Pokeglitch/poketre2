VictoryRoad3Script:
	call VictoryRoad3Script_44996
	call EnableAutoTextBoxDrawing
	ld hl, VictoryRoad3TrainerHeader0
	ld de, VictoryRoad3ScriptPointers
	ld a, [wVictoryRoad3CurScript]
	call ExecuteCurMapScriptInTable
	ld [wVictoryRoad3CurScript], a
	ret

VictoryRoad3Script_44996:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	CheckEventHL EVENT_VICTORY_ROAD_3_BOULDER_ON_SWITCH1
	ret z
	ld a, $1d
	ld [wNewTileBlockID], a
	lb bc, 5, 3
	predef_jump ReplaceTileBlock

VictoryRoad3ScriptPointers:
	dw VictoryRoad3Script0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

VictoryRoad3Script0:
	ld hl, wFlags_0xcd60
	bit 7, [hl]
	res 7, [hl]
	jp z, .asm_449fe
	ld hl, .coordsData_449f9
	call CheckBoulderCoords
	jp nc, .asm_449fe
	ld a, [wCoordIndex]
	cp $1
	jr nz, .asm_449dc
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	SetEvent EVENT_VICTORY_ROAD_3_BOULDER_ON_SWITCH1
	ret
.asm_449dc
	CheckAndSetEvent EVENT_VICTORY_ROAD_3_BOULDER_ON_SWITCH2
	jr nz, .asm_449fe
	ld a, HS_VICTORY_ROAD_3_BOULDER
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_VICTORY_ROAD_2_BOULDER
	ld [wMissableObjectIndex], a
	predef_jump ShowObject

.coordsData_449f9:
	db $05,$03
	db $0F,$17
	db $FF

.asm_449fe
	ld a, VICTORY_ROAD_2
	ld [wDungeonWarpDestinationMap], a
	ld hl, .coordsData_449f9
	call IsPlayerOnDungeonWarp
	ld a, [wCoordIndex]
	cp $1
	jr nz, .asm_44a1b
	ld hl, wd72d
	res 4, [hl]
	ld hl, wd732
	res 4, [hl]
	ret
.asm_44a1b
	ld a, [wd72d]
	bit 4, a
	jp z, CheckFightingMapTrainers
	ret

VictoryRoad3TextPointers:
	dw VictoryRoad3Text1
	dw VictoryRoad3Text2
	dw VictoryRoad3Text3
	dw VictoryRoad3Text4
	dw PickUpItemText
	dw PickUpItemText
	dw BoulderText
	dw BoulderText
	dw BoulderText
	dw BoulderText

VictoryRoad3TrainerHeader0:
	dbEventFlagBit EVENT_BEAT_VICTORY_ROAD_3_TRAINER_0
	db ($1 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VICTORY_ROAD_3_TRAINER_0
	dw VictoryRoad3BattleText2 ; TextBeforeBattle
	dw VictoryRoad3AfterBattleText2 ; TextAfterBattle
	dw VictoryRoad3EndBattleText2 ; TextEndBattle
	dw VictoryRoad3EndBattleText2 ; TextEndBattle

VictoryRoad3TrainerHeader1:
	dbEventFlagBit EVENT_BEAT_VICTORY_ROAD_3_TRAINER_1
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VICTORY_ROAD_3_TRAINER_1
	dw VictoryRoad3BattleText3 ; TextBeforeBattle
	dw VictoryRoad3AfterBattleText3 ; TextAfterBattle
	dw VictoryRoad3EndBattleText3 ; TextEndBattle
	dw VictoryRoad3EndBattleText3 ; TextEndBattle

VictoryRoad3TrainerHeader2:
	dbEventFlagBit EVENT_BEAT_VICTORY_ROAD_3_TRAINER_2
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VICTORY_ROAD_3_TRAINER_2
	dw VictoryRoad3BattleText4 ; TextBeforeBattle
	dw VictoryRoad3AfterBattleText4 ; TextAfterBattle
	dw VictoryRoad3EndBattleText4 ; TextEndBattle
	dw VictoryRoad3EndBattleText4 ; TextEndBattle

VictoryRoad3TrainerHeader3:
	dbEventFlagBit EVENT_BEAT_VICTORY_ROAD_3_TRAINER_3
	db ($4 << 4) ; trainer's view range
	dwEventFlagAddress EVENT_BEAT_VICTORY_ROAD_3_TRAINER_3
	dw VictoryRoad3BattleText5 ; TextBeforeBattle
	dw VictoryRoad3AfterBattleText5 ; TextAfterBattle
	dw VictoryRoad3EndBattleText5 ; TextEndBattle
	dw VictoryRoad3EndBattleText5 ; TextEndBattle

	db $ff

VictoryRoad3Text1:
	TX_ASM
	ld hl, VictoryRoad3TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad3Text2:
	TX_ASM
	ld hl, VictoryRoad3TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad3Text3:
	TX_ASM
	ld hl, VictoryRoad3TrainerHeader2
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad3Text4:
	TX_ASM
	ld hl, VictoryRoad3TrainerHeader3
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad3BattleText2:
	text ""
	fartext _VictoryRoad3BattleText2
	done

VictoryRoad3EndBattleText2:
	text ""
	fartext _VictoryRoad3EndBattleText2
	done

VictoryRoad3AfterBattleText2:
	text ""
	fartext _VictoryRoad3AfterBattleText2
	done

VictoryRoad3BattleText3:
	text ""
	fartext _VictoryRoad3BattleText3
	done

VictoryRoad3EndBattleText3:
	text ""
	fartext _VictoryRoad3EndBattleText3
	done

VictoryRoad3AfterBattleText3:
	text ""
	fartext _VictoryRoad3AfterBattleText3
	done

VictoryRoad3BattleText4:
	text ""
	fartext _VictoryRoad3BattleText4
	done

VictoryRoad3EndBattleText4:
	text ""
	fartext _VictoryRoad3EndBattleText4
	done

VictoryRoad3AfterBattleText4:
	text ""
	fartext _VictoryRoad3AfterBattleText4
	done

VictoryRoad3BattleText5:
	text ""
	fartext _VictoryRoad3BattleText5
	done

VictoryRoad3EndBattleText5:
	text ""
	fartext _VictoryRoad3EndBattleText5
	done

VictoryRoad3AfterBattleText5:
	text ""
	fartext _VictoryRoad3AfterBattleText5
	done
