MACRO _Delay
	IF _NARG == 0
		call DelayFrame
	ELSE
		IF \1 == 1
			call DelayFrame
		ELSE
			IF \1 == 3
				call Delay3
			ELSE
				ld c, \1
				call DelayFrames
			ENDC
		ENDC
	ENDC
ENDM

MACRO lb ; r, hi, lo (bytes)
	ld \1, (\2) << 8 + ((\3) & $ff)
ENDM

MACRO homejump
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, BANK(\1)
	call SetNewBank
	call \1
	jp HomeBankswitchReturn
ENDM

farcall EQUS "callba"

farjump EQUS "jpba"

MACRO callba
	ld b, BANK(\1)
	ld hl, \1
	call Bankswitch
ENDM

MACRO callab
	ld hl, \1
	ld b, BANK(\1)
	call Bankswitch
ENDM

MACRO jpba
	ld b, BANK(\1)
	ld hl, \1
	jp Bankswitch
ENDM

MACRO jpab
	ld hl, \1
	ld b, BANK(\1)
	jp Bankswitch
ENDM

MACRO validateCoords
	IF \1 >= SCREEN_WIDTH
		fail "x coord out of range"
	ENDC
	IF \2 >= SCREEN_HEIGHT
		fail "y coord out of range"
	ENDC
ENDM

;\1 = r
;\2 = X
;\3 = Y
;\4 = which tilemap (optional)
MACRO coord
	validateCoords \2, \3
	IF _NARG >= 4
		ld \1, \4 + SCREEN_WIDTH * \3 + \2
	ELSE
		ld \1, wTileMap + SCREEN_WIDTH * \3 + \2
	ENDC
ENDM

;\1 = X
;\2 = Y
;\3 = which tilemap (optional)
MACRO aCoord
	validateCoords \1, \2
	IF _NARG >= 3
		ld a, [\3 + SCREEN_WIDTH * \2 + \1]
	ELSE
		ld a, [wTileMap + SCREEN_WIDTH * \2 + \1]
	ENDC
ENDM

;\1 = X
;\2 = Y
;\3 = which tilemap (optional)
MACRO Coorda
	validateCoords \1, \2
	IF _NARG >= 3
		ld [\3 + SCREEN_WIDTH * \2 + \1], a
	ELSE
		ld [wTileMap + SCREEN_WIDTH * \2 + \1], a
	ENDC
ENDM

;\1 = X
;\2 = Y
;\3 = which tilemap (optional)
MACRO dwCoord
	validateCoords \1, \2
	IF _NARG >= 3
		dw \3 + SCREEN_WIDTH * \2 + \1
	ELSE
		dw wTileMap + SCREEN_WIDTH * \2 + \1
	ENDC
ENDM

;\1 = r
;\2 = X
;\3 = Y
;\4 = map width
MACRO overworldMapCoord
	ld \1, wOverworldMap + ((\2) + 3) + (((\3) + 3) * ((\4) + (3 * 2)))
ENDM

; macro for two nibbles
MACRO dn
	db (\1 << 4 | \2)
ENDM

; macro for putting a byte then a word
MACRO dbw
	db \1
	dw \2
ENDM

MACRO dba
	dbw BANK(\1), \1
ENDM

MACRO dwb
	dw \1
	db \2
ENDM

MACRO dab
	dwb \1, BANK(\1)
ENDM

MACRO dbbw
	db \1, \2
	dw \3
ENDM

; Predef macro.
MACRO predef_const
	const \1PredefID
ENDM

MACRO add_predef
\1Predef::
	db BANK(\1)
	dw \1
ENDM

MACRO predef_id
	ld a, (\1Predef - PredefPointers) / 3
ENDM

MACRO predef
	predef_id \1
	call Predef
ENDM

MACRO predef_jump
	predef_id \1
	jp Predef
ENDM

MACRO tx_pre_const
	const \1_id
ENDM

MACRO add_tx_pre
\1_id:: dw \1
ENDM

MACRO db_tx_pre
	db (\1_id - TextPredefs) / 2 + 1
ENDM

MACRO tx_pre_id
	ld a, (\1_id - TextPredefs) / 2 + 1
ENDM

MACRO tx_pre
	tx_pre_id \1
	call PrintPredefTextID
ENDM

MACRO tx_pre_jump
	tx_pre_id \1
	jp PrintPredefTextID
ENDM

MACRO ldPal
	ld \1, \2 << 6 | \3 << 4 | \4 << 2 | \5
ENDM
