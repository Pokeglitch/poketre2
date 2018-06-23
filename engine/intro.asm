MOVE_GENGAR_RIGHT   EQU 0
MOVE_GENGAR_LEFT    EQU 1
MOVE_NIDORINO_RIGHT EQU -1

ANIMATION_END       EQU 80

PlayIntro:
	xor a
	ld [hJoyHeld], a
	inc a
	ld [H_AUTOBGTRANSFERENABLED], a
	call PlayShootingStar
	call PlayIntroScene
	call GBFadeOutToWhite
	xor a
	ld [hSCX], a
	ld [H_AUTOBGTRANSFERENABLED], a
	call ClearSprites
	call DelayFrame
	ret

; c = which sprite to draw
DrawEkansTiles:
	ld b, 0
	ld hl, EkansSpriteDims
	ld a, 5
	call AddNTimes
	push hl ; hl = row for this sprite
	call IntroClearMiddleOfScreen
	pop hl
	ld a, [hli]
	push af
	ld b, [hl]
	inc hl
	ld c, [hl] ; bc = sprite dims
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a ; hl = location to draw
	pop af ; a = first sprite offset
	lb de, 0, SCREEN_WIDTH
	
; draw the tiles
.row_loop
	push hl
	push bc
	
.col_loop
	ld [hli], a
	inc a
	dec c
	jr nz, .col_loop
	
	pop bc
	pop hl
	dec b
	ret z
	
	add hl, de
	jr .row_loop	
	
EkansSpriteDims:
; starting tile id, height, width, location on screen
	db 0, 5, 6
	dwCoord 11, 9
	db (FightIntroBackMon2 - FightIntroBackMon) / BYTES_PER_TILE, 7, 7
	dwCoord 11, 7
	db (FightIntroBackMon3 - FightIntroBackMon) / BYTES_PER_TILE, 5, 9
	dwCoord 11, 9
	
PlayIntroScene:
	ld b, SET_PAL_NIDORINO_INTRO
	call RunPaletteCommand
	ldPal a, BLACK, DARK_GRAY, LIGHT_GRAY, WHITE
	ld [rBGP], a
	ld [rOBP0], a
	ld [rOBP1], a
	ld a, -16
	ld [hSCX], a
	ld c, 0
	call DrawEkansTiles
	ld a, 0
	ld [wBaseCoordX], a
	ld a, 72
	ld [wBaseCoordY], a
	lb bc, 7, 6
	call InitIntroNidorinoOAM
	lb de, 80 / 2, MOVE_NIDORINO_RIGHT
	call IntroMoveMon
	ret c

; hip
	ld a, SFX_INTRO_HIP
	call PlaySound
	xor a
	ld [wIntroNidorinoBaseTile], a
	ld de, IntroNidorinoAnimation1
	call AnimateIntroNidorino
; hop
	ld a, SFX_INTRO_HOP
	call PlaySound
	ld de, IntroNidorinoAnimation2
	call AnimateIntroNidorino
	ld c, 10
	call CheckForUserInterruption
	ret c

; hip
	ld a, SFX_INTRO_HIP
	call PlaySound
	ld de, IntroNidorinoAnimation1
	call AnimateIntroNidorino
; hop
	ld a, SFX_INTRO_HOP
	call PlaySound
	ld de, IntroNidorinoAnimation2
	call AnimateIntroNidorino
	ld c, 30
	call CheckForUserInterruption
	ret c

; raise
	ld c, 1
	call DrawEkansTiles
	ld a, SFX_INTRO_RAISE
	call PlaySound
	lb de, 8 / 2, MOVE_GENGAR_LEFT
	call IntroMoveMon
	ld c, 30
	call CheckForUserInterruption
	ret c

; slash
	ld c, 2
	call DrawEkansTiles
	ld a, SFX_INTRO_CRASH
	call PlaySound
	lb de, 16 / 2, MOVE_GENGAR_RIGHT
	call IntroMoveMon
; hip
	ld a, SFX_INTRO_HIP
	call PlaySound
	ld a, (FightIntroFrontMon2 - FightIntroFrontMon) / BYTES_PER_TILE
	ld [wIntroNidorinoBaseTile], a
	ld de, IntroNidorinoAnimation3
	call AnimateIntroNidorino
	ld c, 30
	call CheckForUserInterruption
	ret c

	lb de, 8 / 2, MOVE_GENGAR_LEFT
	call IntroMoveMon
	ld c, 0
	call DrawEkansTiles
	ld c, 60
	call CheckForUserInterruption
	ret c

; hip
	ld a, SFX_INTRO_HIP
	call PlaySound
	xor a
	ld [wIntroNidorinoBaseTile], a
	ld de, IntroNidorinoAnimation4
	call AnimateIntroNidorino
; hop
	ld a, SFX_INTRO_HOP
	call PlaySound
	ld de, IntroNidorinoAnimation5
	call AnimateIntroNidorino
	ld c, 20
	call CheckForUserInterruption
	ret c

	ld a, (FightIntroFrontMon2 - FightIntroFrontMon) / BYTES_PER_TILE
	ld [wIntroNidorinoBaseTile], a
	ld de, IntroNidorinoAnimation6
	call AnimateIntroNidorino
	ld c, 30
	call CheckForUserInterruption
	ret c

; lunge
	ld a, SFX_INTRO_LUNGE
	call PlaySound
	ld a, (FightIntroFrontMon3 - FightIntroFrontMon) / BYTES_PER_TILE
	ld [wIntroNidorinoBaseTile], a
	ld de, IntroNidorinoAnimation7
	jp AnimateIntroNidorino

AnimateIntroNidorino:
	ld a, [de]
	cp ANIMATION_END
	ret z
	ld [wBaseCoordY], a
	inc de
	ld a, [de]
	ld [wBaseCoordX], a
	push de
	ld c, 6 * 7
	call UpdateIntroNidorinoOAM
	ld c, 5
	call DelayFrames
	pop de
	inc de
	jr AnimateIntroNidorino

UpdateIntroNidorinoOAM:
	; The sprite is 2 tiles too large for OAM,
	; so skip the first 2 because they are
	; blank in each sprite anyway
	ld hl, wOAMBuffer - 2 * 4
	ld a, [wIntroNidorinoBaseTile]
	ld d, a
.loop
	ld a, [wBaseCoordY]
	add [hl]
	ld [hli], a ; Y
	ld a, [wBaseCoordX]
	add [hl]
	ld [hli], a ; X
	ld a, d
	ld [hli], a ; tile
	inc hl
	inc d
	dec c
	jr nz, .loop
	ret

InitIntroNidorinoOAM:
	; The sprite is 2 tiles too large for OAM,
	; so skip the first 2 because they are
	; blank in each sprite anyway
	ld hl, wOAMBuffer - 2 * 4
	ld d, 0
.loop
	push bc
	ld a, [wBaseCoordY]
	ld e, a
.innerLoop
	ld a, e
	add 8
	ld e, a
	ld [hli], a ; Y
	ld a, [wBaseCoordX]
	ld [hli], a ; X
	ld a, d
	ld [hli], a ; tile
	ld a, OAM_BEHIND_BG
	ld [hli], a ; attributes
	inc d
	dec c
	jr nz, .innerLoop
	ld a, [wBaseCoordX]
	add 8
	ld [wBaseCoordX], a
	pop bc
	dec b
	jr nz, .loop
	ret

IntroClearScreen:
	ld hl, vBGMap1
	ld bc, BG_MAP_WIDTH * SCREEN_HEIGHT
	jr IntroClearCommon

IntroClearMiddleOfScreen:
; clear the area of the tile map between the black bars on the top and bottom
	coord hl, 0, 4
	ld bc, SCREEN_WIDTH * 10

IntroClearCommon:
	ld [hl], 0
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, IntroClearCommon
	ret

IntroPlaceBlackTiles:
	ld a, $1B ; Ekans conveniently has an all black tile
.loop
	ld [hli], a
	dec c
	jr nz, .loop
	ret

IntroMoveMon:
; d = number of times to move the mon (2 pixels each time)
; e: 0 = move Gengar right, 1 = move Gengar left, -1 = move Nidorino right
	ld a, e
	cp -1
	jr z, .moveNidorinoRight
	cp 1
	jr z, .moveGengarLeft
; move Gengar right
	ld a, [hSCX]
	dec a
	dec a
	jr .next
.moveNidorinoRight
	push de
	ld a, 2
	ld [wBaseCoordX], a
	xor a
	ld [wBaseCoordY], a
	ld c, 6 * 7
	call UpdateIntroNidorinoOAM
	pop de
.moveGengarLeft
	ld a, [hSCX]
	inc a
	inc a
.next
	ld [hSCX], a
	push de
	ld c, 2
	call CheckForUserInterruption
	pop de
	ret c
	dec d
	jr nz, IntroMoveMon
	ret

CopyTileIDsFromList_ZeroBaseTileID:
	ld c, 0
	predef_jump CopyTileIDsFromList

LoadIntroGraphics:
	ld hl, FightIntroBackMon
	ld de, vChars2
	ld bc, FightIntroBackMonEnd - FightIntroBackMon
	ld a, BANK(FightIntroBackMon)
	call FarCopyData2
	ld hl, FightIntroFrontMon
	ld de, vChars0
	ld bc, FightIntroFrontMonEnd - FightIntroFrontMon
	ld a, BANK(FightIntroFrontMon)
	jp FarCopyData2

PlayShootingStar:
	ld b, SET_PAL_GAME_FREAK_INTRO
	call RunPaletteCommand
	callba LoadCopyrightAndTextBoxTiles
	ldPal a, BLACK, DARK_GRAY, LIGHT_GRAY, WHITE
	ld [rBGP], a
	ld c, 180
	call DelayFrames
	call ClearScreen
	call DisableLCD
	xor a
	ld [wCurOpponent], a
	call IntroDrawBlackBars
	call LoadIntroGraphics
	call EnableLCD
	ld hl, rLCDC
	res 5, [hl]
	set 3, [hl]
	ld c, 16
	call DelayFrames
	ld a, BANK(Music_IntroBattle)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, MUSIC_INTRO_BATTLE
	ld [wNewSoundID], a
	call PlaySound
	call IntroClearMiddleOfScreen
	call ClearSprites
	jp Delay3

IntroDrawBlackBars:
; clear the screen and draw black bars on the top and bottom
	call IntroClearScreen
	coord hl, 0, 0
	ld c, SCREEN_WIDTH * 4
	call IntroPlaceBlackTiles
	coord hl, 0, 14
	ld c, SCREEN_WIDTH * 4
	call IntroPlaceBlackTiles
	ld hl, vBGMap1
	ld c, BG_MAP_WIDTH * 4
	call IntroPlaceBlackTiles
	ld hl, vBGMap1 + BG_MAP_WIDTH * 14
	ld c,  BG_MAP_WIDTH * 4
	jp IntroPlaceBlackTiles

IntroNidorinoAnimation0:
	db 0, 0
	db ANIMATION_END

IntroNidorinoAnimation1:
; This is a sequence of pixel movements for part of the Nidorino animation. This
; list describes how Nidorino should hop.
; First byte is y movement, second byte is x movement
	db  0, 0
	db -2, 2
	db -1, 2
	db  1, 2
	db  2, 2
	db ANIMATION_END

IntroNidorinoAnimation2:
; This is a sequence of pixel movements for part of the Nidorino animation.
; First byte is y movement, second byte is x movement
	db  0,  0
	db -2, -2
	db -1, -2
	db  1, -2
	db  2, -2
	db ANIMATION_END

IntroNidorinoAnimation3:
; This is a sequence of pixel movements for part of the Nidorino animation.
; First byte is y movement, second byte is x movement
	db   0, 0
	db -12, 6
	db  -8, 6
	db   8, 6
	db  12, 6
	db ANIMATION_END

IntroNidorinoAnimation4:
; This is a sequence of pixel movements for part of the Nidorino animation.
; First byte is y movement, second byte is x movement
	db  0,  0
	db -8, -4
	db -4, -4
	db  4, -4
	db  8, -4
	db ANIMATION_END

IntroNidorinoAnimation5:
; This is a sequence of pixel movements for part of the Nidorino animation.
; First byte is y movement, second byte is x movement
	db  0, 0
	db -8, 4
	db -4, 4
	db  4, 4
	db  8, 4
	db ANIMATION_END

IntroNidorinoAnimation6:
; This is a sequence of pixel movements for part of the Nidorino animation.
; First byte is y movement, second byte is x movement
	db 0, 0
	db 2, 0
	db 2, 0
	db 0, 0
	db ANIMATION_END

IntroNidorinoAnimation7:
; This is a sequence of pixel movements for part of the Nidorino animation.
; First byte is y movement, second byte is x movement
	db -8, -16
	db -7, -14
	db -6, -12
	db -4, -10
	db ANIMATION_END

FightIntroBackMon:
	INCBIN "gfx/intro_ekans_1.2bpp"
FightIntroBackMon2:
	INCBIN "gfx/intro_ekans_2.2bpp"
FightIntroBackMon3:
	INCBIN "gfx/intro_ekans_3.2bpp"
FightIntroBackMonEnd:

FightIntroFrontMon:
	INCBIN "gfx/intro_meowth_1.2bpp"
FightIntroFrontMon2:
	INCBIN "gfx/intro_meowth_2.2bpp"
FightIntroFrontMon3:
	INCBIN "gfx/intro_meowth_3.2bpp"
FightIntroFrontMonEnd: