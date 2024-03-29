AgathaScript:
	call AgathaShowOrHideExitBlock
	call EnableAutoTextBoxDrawing
	ld de, AgathaScriptPointers
	ld a, [wAgathaCurScript]
	call ExecuteCurMapScriptInTable
	ld [wAgathaCurScript], a
	ret

AgathaShowOrHideExitBlock:
; Blocks or clears the exit to the next room.
	ld hl, wCurrentMapScriptFlags
	bit 5, [hl]
	res 5, [hl]
	ret z
	CheckEvent EVENT_BEAT_AGATHAS_ROOM_TRAINER_0
	jr z, .blockExitToNextRoom
	ld a, $e
	jp .setExitBlock
.blockExitToNextRoom
	ld a, $3b
.setExitBlock:
	ld [wNewTileBlockID], a
	lb bc, 0, 2
	predef_jump ReplaceTileBlock

ResetAgathaScript:
	xor a
	ld [wAgathaCurScript], a
	ret

AgathaScriptPointers:
	dw AgathaScript0
	dw DisplayEnemyTrainerTextAndStartBattle
	dw AgathaScript2
	dw AgathaScript3
	dw AgathaScript4

AgathaScript4:
	ret

AgathaScriptWalkIntoRoom:
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
	ld [wAgathaCurScript], a
	ld [wCurMapScript], a
	ret

AgathaScript0:
	ld hl, AgathaEntranceCoords
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
	CheckAndSetEvent EVENT_AUTOWALKED_INTO_AGATHAS_ROOM
	jr z, AgathaScriptWalkIntoRoom
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
	ld [wAgathaCurScript], a
	ld [wCurMapScript], a
	ret

AgathaEntranceCoords:
	db $0A,$04
	db $0A,$05
	db $0B,$04
	db $0B,$05
	db $FF

AgathaScript3:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld [wAgathaCurScript], a
	ld [wCurMapScript], a
	ret

AgathaScript2:
	call EndTrainerBattle
	ld a, [wIsInBattle]
	cp $ff
	jp z, ResetAgathaScript
	ld a, $1
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $1
	ld [wGaryCurScript], a
	ret

AgathaTextPointers:
	dw AgathaText1
	dw AgathaDontRunAwayText

AgathaTrainerHeader0:
	db 0 ; former event flag bit index
	db ($0 << 4) ; trainer's view range
	dw 0 ; former event flag address
	dw AgathaBeforeBattleText ; TextBeforeBattle
	dw AgathaAfterBattleText ; TextAfterBattle
	dw AgathaEndBattleText ; TextEndBattle
	dw AgathaEndBattleText ; TextEndBattle

	db $ff

AgathaText1:
	asmtext
	ld hl, AgathaTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

AgathaBeforeBattleText:
	fartext _AgathaBeforeBattleText
	done

AgathaEndBattleText:
	fartext _AgathaEndBattleText
	done

AgathaAfterBattleText:
	fartext _AgathaAfterBattleText
	done

AgathaDontRunAwayText:
	fartext _AgathaDontRunAwayText
	done
