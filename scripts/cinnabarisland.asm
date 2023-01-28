CinnabarIslandScript:
	call EnableAutoTextBoxDrawing
	ld hl, wCurrentMapScriptFlags
	set 5, [hl]
	ResetEvent EVENT_MANSION_SWITCH_ON
	ResetEvent EVENT_LAB_STILL_REVIVING_FOSSIL
	ld hl, CinnabarIslandScriptPointers
	ld a, [wCinnabarIslandCurScript]
	jp CallFunctionInTable

CinnabarIslandScriptPointers:
	dw CinnabarIslandScript0
	dw CinnabarIslandScript1

CinnabarIslandScript0:
	ld b, SECRET_KEY
	call IsItemInBag
	ret nz
	ld a, [wYCoord]
	cp $4
	ret nz
	ld a, [wXCoord]
	cp $12
	ret nz
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, $8
	ld [hSpriteIndexOrTextID], a
	call DisplayTextID
	xor a
	ld [hJoyHeld], a
	ld a, $1
	ld [wSimulatedJoypadStatesIndex], a
	ld a, D_DOWN
	ld [wSimulatedJoypadStatesEnd], a
	call StartSimulatingJoypadStates
	xor a
	ld [wSpriteStateData1 + 9], a
	ld [wJoyIgnore], a
	ld a, $1
	ld [wCinnabarIslandCurScript], a
	ret

CinnabarIslandScript1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	ld a, $0
	ld [wCinnabarIslandCurScript], a
	ret

CinnabarIslandTrainerHeader0:
	db TrainerHeaderTerminator

CinnabarIslandTextPointers:
	dw CinnabarIslandText1
	dw CinnabarIslandText2
	dw CinnabarIslandText3
	dw MartSignText
	dw PokeCenterSignText
	dw CinnabarIslandText6
	dw CinnabarIslandText7
	dw CinnabarIslandText8

CinnabarIslandText8:
	fartext _CinnabarIslandText8
	done

CinnabarIslandText1:
	fartext _CinnabarIslandText1
	done

CinnabarIslandText2:
	fartext _CinnabarIslandText2
	done

CinnabarIslandText3:
	fartext _CinnabarIslandText3
	done

CinnabarIslandText6:
	fartext _CinnabarIslandText6
	done

CinnabarIslandText7:
	fartext _CinnabarIslandText7
	done
