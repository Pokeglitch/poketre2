RedsHouse2FScript:
	call EnableAutoTextBoxDrawing
	ld hl, RedsHouse2FScriptPointers
	ld a, [wRedsHouse2CurScript]
	jp RunIndexedMapScript

RedsHouse2FScriptPointers:
	dw RedsHouse2FScript0

RedsHouse2FScript0:
	xor a
	ld [hJoyHeld], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, -1
	ld [wRedsHouse2CurScript], a
	ret
