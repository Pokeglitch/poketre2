VictoryRoad1Script:
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	call nz, .next
	call EnableAutoTextBoxDrawing
	ld hl, VictoryRoad1TrainerHeader0
	ld de, VictoryRoad1ScriptPointers
	ld a, [wVictoryRoad1CurScript]
	call ExecuteCurMapScriptInTable
	ld [wVictoryRoad1CurScript], a
	ret
.next
	CheckEvent EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH
	ret z
	ld a, $1d
	ld [wNewTileBlockID], a
	lb bc, 6, 4
	predef_jump ReplaceTileBlock

VictoryRoad1ScriptPointers:
	dw VictoryRoad1Script0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle

VictoryRoad1Script0:
	CheckEvent EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH
	jp nz, CheckFightingMapTrainers
	ld hl, CoordsData_5da5c
	call CheckBoulderCoords
	jp nc, CheckFightingMapTrainers
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	SetEvent EVENT_VICTORY_ROAD_1_BOULDER_ON_SWITCH
	ret

CoordsData_5da5c:
	db $0D,$11,$FF

VictoryRoad1TextPointers:
	dw VictoryRoad1Text1
	dw VictoryRoad1Text2
	dw PickUpItemText
	dw PickUpItemText
	dw BoulderText
	dw BoulderText
	dw BoulderText

VictoryRoad1TrainerHeader0:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw VictoryRoad1BattleText1 ; TextBeforeBattle
	dw VictoryRoad1AfterBattleText1 ; TextAfterBattle
	dw VictoryRoad1EndBattleText1 ; TextEndBattle
	dw VictoryRoad1EndBattleText1 ; TextEndBattle

VictoryRoad1TrainerHeader1:
	db 0 ; former event flag bit index
	db ($2 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw VictoryRoad1BattleText2 ; TextBeforeBattle
	dw VictoryRoad1AfterBattleText2 ; TextAfterBattle
	dw VictoryRoad1EndBattleText2 ; TextEndBattle
	dw VictoryRoad1EndBattleText2 ; TextEndBattle

	db $ff

VictoryRoad1Text1:
	asmtext
	ld hl, VictoryRoad1TrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad1Text2:
	asmtext
	ld hl, VictoryRoad1TrainerHeader1
	call TalkToTrainer
	jp TextScriptEnd

VictoryRoad1BattleText1:
	fartext _VictoryRoad1BattleText1
	done

VictoryRoad1EndBattleText1:
	fartext _VictoryRoad1EndBattleText1
	done

VictoryRoad1AfterBattleText1:
	fartext _VictoryRoad1AfterBattleText1
	done

VictoryRoad1BattleText2:
	fartext _VictoryRoad1BattleText2
	done

VictoryRoad1EndBattleText2:
	fartext _VictoryRoad1EndBattleText2
	done

VictoryRoad1AfterBattleText2:
	fartext _VictoryRoad1AfterBattleText2
	done
