LoreleiScript:
	call LoreleiShowOrHideExitBlock
	call EnableAutoTextBoxDrawing
	ld de, LoreleiScriptPointers
	ld a, [wLoreleiCurScript]
	call ExecuteCurMapScriptInTable
	ld [wLoreleiCurScript], a
	ret

LoreleiShowOrHideExitBlock:
; Blocks or clears the exit to the next room.
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	ld hl, wBeatLorelei
	set 1, [hl]
	CheckEvent EVENT_BEAT_LORELEIS_ROOM_TRAINER_0
	jr z, .blockExitToNextRoom
	ld a, $5
	jr .setExitBlock
.blockExitToNextRoom
	ld a, $24
.setExitBlock
	ld [wNewTileBlockID], a
	lb bc, 0, 2
	predef_jump ReplaceTileBlock

ResetLoreleiScript:
	xor a
	ld [wLoreleiCurScript], a
	ret

LoreleiScriptPointers:
	dw LoreleiScript0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw LoreleiScript2
	dw LoreleiScript3
	dw LoreleiScript4

LoreleiScript4:
	ret

LoreleiScriptWalkIntoRoom:
; Walk six steps upward.
	ld hl, wSimulatedJoypadStatesEnd
	ld a, D_UP
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $6
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [wLoreleiCurScript], a
	ld [wCurMapScript], a
	ret

LoreleiScript0:
	ld hl, LoreleiEntranceCoords
	call ArePlayerCoordsInArray
	jp nc, CheckFightingMapTrainers
	xor a
	ld [hJoyPressed], a
	ld [hJoyHeld], a
	ld [wSimulatedJoypadStatesEnd], a
	ld [wSimulatedJoypadStatesIndex], a
	ld a, [wCoordIndex]
	cp $3  ; Is player standing one tile above the exit?
	jr c, .stopPlayerFromLeaving
	CheckAndSetEvent EVENT_AUTOWALKED_INTO_LORELEIS_ROOM
	jr z, LoreleiScriptWalkIntoRoom
.stopPlayerFromLeaving
	ld a, $2
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID  ; "Don't run away!"
	ld a, D_UP
	ld [wSimulatedJoypadStatesEnd], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $3
	ld [wLoreleiCurScript], a
	ld [wCurMapScript], a
	ret

LoreleiEntranceCoords:
	db $0A,$04
	db $0A,$05
	db $0B,$04
	db $0B,$05
	db $FF

LoreleiScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld [wLoreleiCurScript], a
	ld [wCurMapScript], a
	ret

LoreleiScript2:
	call EndTrainerBattle
	ld a, [wIsInBattle]
	cp $ff
	jp z, ResetLoreleiScript
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	jp DisplayTextID

LoreleiTextPointers:
	dw LoreleiText1
	dw LoreleiDontRunAwayText

LoreleiTrainerHeader0:
	db 0 ; former event flag bit index
	db ($0 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw LoreleiBeforeBattleText ; TextBeforeBattle
	dw LoreleiAfterBattleText ; TextAfterBattle
	dw LoreleiEndBattleText ; TextEndBattle
	dw LoreleiEndBattleText ; TextEndBattle

	db $ff

LoreleiText1:
	asmtext
	ld hl, LoreleiTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

LoreleiBeforeBattleText:
	fartext _LoreleiBeforeBattleText
	done

LoreleiEndBattleText:
	fartext _LoreleiEndBattleText
	done

LoreleiAfterBattleText:
	fartext _LoreleiAfterBattleText
	done

LoreleiDontRunAwayText:
	fartext _LoreleiDontRunAwayText
	done
